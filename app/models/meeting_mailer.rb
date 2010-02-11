class MeetingMailer < ActionMailer::Base
  helper :application 

  def scheduled(meeting)
    subject    "The #{meeting.title} has been scheduled"
    recipients 'Robert Walker <robert4723@me.com>'
    from       'CocoaHeads Atlanta <noreply@cocoaheadsatlanta.org>'
    sent_on    Time.now

    body       :meeting => meeting
  end

  def reminder(meeting)
    days_from_now = meeting.scheduled_at.to_date - Time.now.to_date
    meeting_at = humanize_meeting_at(days_from_now)
    subject    "Reminder: #{meeting.title} is #{meeting_at}"
    recipients 'Robert Walker <robert4723@me.com>'
    from       'CocoaHeads Atlanta <noreply@cocoaheadsatlanta.org>'
    sent_on    Time.now

    body       :meeting => meeting, :meeting_at => meeting_at
  end

  private
  def humanize_meeting_at(days_from_now)
    case days_from_now
    when 7
      "coming up in one week"
    when 1
      "tomorrow"
    when 0
      "today"
    else
      "coming up in #{days_from_now} days"
    end
  end
end
