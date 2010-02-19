require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  def after_initialize
    set_defaults
  end

  named_scope :active, :conditions => { :state => "active" }, :order => "logged_in_at DESC"
  named_scope :not_deleted, :conditions => "state <> 'deleted'", :order => "logged_in_at DESC"

  has_and_belongs_to_many :roles
  has_many :attendances, :class_name => "Attendee", :dependent => :destroy
  has_many :meetings, :through => :attendances
  has_many :social_networks, :dependent => :destroy

  # Gravatar support
  is_gravtastic :default => :wavatar, :size => 40

  before_validation_on_create :make_fake_login_password
  after_validation :normalize_identity

  validates_presence_of     :identity_url
  validates_uniqueness_of   :identity_url
  validates_presence_of     :login
  validates_length_of       :login,         :within => 3..40
  validates_uniqueness_of   :login          
  validates_format_of       :login,         :with => Authentication.login_regex, 
                                            :message => Authentication.bad_login_message

  validates_format_of       :first_name,    :with => Authentication.name_regex,
                                            :message => Authentication.bad_name_message,
                                            :allow_nil => true

  validates_format_of       :last_name,     :with => Authentication.name_regex,
                                            :message => Authentication.bad_name_message,
                                            :allow_nil => true

  validates_length_of       :first_name,    :maximum => 100
  validates_length_of       :last_name,     :maximum => 100

  validates_presence_of     :email          
  validates_length_of       :email,         :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email          
  validates_format_of       :email,         :with => Authentication.email_regex,
                                            :message => Authentication.bad_email_message

  # ---------------------------------------
  # has_role? simply needs to return true or false whether a user has a role or not.
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end
  
  def admin?
    has_role?("admin")
  end
  # ---------------------------------------  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :identity_url, :login, :email, :first_name, :last_name,
                  :password, :password_confirmation, :logged_in_at, :subscribe_to_chatter

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login.downcase} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def full_name
    [ self.first_name || '', self.last_name || '' ].join(' ').strip
  end

  protected
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end

  def normalize_identity
    if self.identity_url.present?
      self.identity_url = OpenIdAuthentication.normalize_identifier(self.identity_url)
    end
  end

  def make_fake_login_password
    self.login = self.class.make_token if self.login.blank?
    self.password = self.class.make_token if self.password.blank?
    self.password_confirmation = self.password
  end

  private
  def set_defaults
    self.logged_in_at = Time.now
  end
end
