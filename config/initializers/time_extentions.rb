class Time
  def self.time_at_wnum_wday_hour(wnum = 2, wday = 4, hour_of_day = 19, min_of_hour = 0)
    offsets = [ 6, 5, 4, 3, 2, 1, 0].rotate(wday + 1)
    first = Time.now.next_month.beginning_of_month
    first + offsets[first.wday].days + (wnum - 1).week + hour_of_day.hours + min_of_hour.minutes
  end
end
