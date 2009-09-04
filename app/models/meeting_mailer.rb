class MeetingMailer < ActionMailer::Base
  helper :application 

  def scheduled_notification(meeting)
    subject    "The #{month_name(meeting)} CocoaHeads Atlanta meeting has been scheduled"
    recipients 'Robert Walker <robert348@me.com>'
    from       'Robert Walker <robert4723@me.com>'
    sent_on    Time.now

    body       :meeting => meeting
  end

  def reminder(meeting)
    subject    "Reminder: CocoaHeads Atlanta meeting is tomorrow"
    recipients 'Robert Walker <robert348@me.com>'
    from       'Robert Walker <robert4723@me.com>'
    sent_on    Time.now

    body       :meeting => meeting
  end

  protected
  def month_name(meeting)
    meeting.scheduled_at.strftime('%B')
  end
end
