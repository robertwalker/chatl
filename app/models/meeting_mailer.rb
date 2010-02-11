class MeetingMailer < ActionMailer::Base
  helper :application 

  def scheduled(meeting)
    subject    "The #{meeting.title} has been scheduled"
    recipients 'robert4723@me.com'
    from       'noreply@cocoaheadsatlanta.org'
    sent_on    Time.now

    body       :meeting => meeting
  end

  def reminder(meeting)
    days_from_now = meeting.scheduled_at.to_date - Time.now.to_date
    case days_from_now
    when 7
      meeting_at = "in one week"
    when 1
      meeting_at = "tomorrow"
    else
      meeting_at = "#{days_from_now} days"
    end
    subject    "Reminder: #{meeting.title} is #{meeting_at}"
    recipients 'robert4723@me.com'
    from       'noreply@cocoaheadsatlanta.org'
    sent_on    Time.now

    body       :meeting => meeting, :meeting_at => meeting_at
  end
end
