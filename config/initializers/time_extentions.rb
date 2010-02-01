class Time
  def self.time_at_wnum_wday_hour(wnum = 2, wday = 4, hour_offset = 24, minute_offset = 0)
    offsets = [ 6, 5, 4, 3, 2, 1, 0].rotate(wday + 1)
    first = Time.now.utc.next_month.beginning_of_month
    first + offsets[first.wday].days + (wnum - 1).week + hour_offset.hours + minute_offset.minutes
  end
end
