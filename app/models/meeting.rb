class Meeting < ActiveRecord::Base
  DETAILS_TEMPLATE = <<TEMPLATE
h2. Presentation topics

* *Topic 1* - Presented by [member_name]
* *Topic 2* - Presented by [member_name]

h2. After meeting socializing

Join us for drinks and conversion at [venue].
TEMPLATE

  has_many :attendees
  has_many :users, :through => :attendees

  def after_initialize
    set_defaults
  end

  has_one :venue

  validates_presence_of :venue_id, :scheduled_at, :details

  protected
  def set_defaults
    self.scheduled_at ||= Time.time_at_wnum_wday_hour
    self.details ||= Meeting::DETAILS_TEMPLATE
  end
end
