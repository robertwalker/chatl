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

  named_scope :recent, { :order => "scheduled_at DESC", :limit => 12 }

  named_scope :past, lambda {
    { :conditions => [ 'scheduled_at < ?', Time.now ] }
  }

  named_scope :upcoming, lambda {
    { :conditions => [ 'scheduled_at >= ?', Time.now ], :order => "scheduled_at" }
  }

  validates_presence_of :title, :venue_id, :scheduled_at, :details

  def self.next_upcoming
    Meeting.upcoming.first
  end

  def attendee_with_user(user)
    self.attendees.find_by_user_id(user.id) if user
  end

  def send_notification?
    (self.scheduled_at.to_date - Time.now.to_date == 7 && 
      self.notification_sent != "week") ||
      (self.scheduled_at.to_date - Time.now.to_date == 1 &&
      self.notification_sent != 'day')
  end

  def update_notification_sent
    case self.scheduled_at.to_date - Time.now.to_date
    when 7
      self.update_attribute(:notification_sent, 'week')
    when 1
      self.update_attribute(:notification_sent, 'day')
    else
      return false
    end
  end

  protected
  def set_defaults
    self.scheduled_at ||= Time.time_at_wnum_wday_hour
    self.details ||= Meeting::DETAILS_TEMPLATE
  end
end
