class Meeting < ActiveRecord::Base
  def after_initialize
    set_defaults
  end
  
  has_one :venue
  
  validates_presence_of :venue_id, :scheduled_at, :details
  
  protected
  def set_defaults
    self.scheduled_at = second_thursday_next_month if self.scheduled_at.nil?
  end
  
  def second_thursday_next_month
    wday_map = { 0 => 4, 1 => 3, 2 => 2, 3 => 1, 4 => 0, 5 => 6, 6 => 5 }
    next_month = Time.now.next_month.beginning_of_month.utc
    next_month + wday_map[next_month.wday].days + 1.week + 19.hours
  end
end
