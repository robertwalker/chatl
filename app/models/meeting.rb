class Meeting < ActiveRecord::Base
  DETAILS_TEMPLATE = <<TEMPLATE
h2. Presentation topics

* *Topic 1* - Presented by [member_name]
* *Topic 2* - Presented by [member_name]

h2. After meeting socializing

Join us for drinks and conversion at [venue].
TEMPLATE

  def after_initialize
    set_defaults
  end

  has_many :attendees, :dependent => :destroy
  has_many :users, :through => :attendees
  belongs_to :venue

  named_scope :next_scheduled, lambda {
    { :conditions => [ 'scheduled_at >= ?', Time.now ], :order => "scheduled_at", :limit => 1 }
  }

  validates_presence_of :venue_id, :scheduled_at, :details

  def attendee_with_user(user)
    self.attendees.find_by_user_id(user.id) if user
  end

  protected
  def set_defaults
    self.scheduled_at ||= Time.time_at_wnum_wday_hour
    self.details ||= Meeting::DETAILS_TEMPLATE
  end
end
