class MeetingMailer < ActionMailer::Base
  def scheduled_notification(meeting)
    subject    "The #{month_name(meeting)} CocoaHeads Atlanta meeting has been scheduled"
    recipients 'list@cocoaheadsatlanta.org'
    from       'Michael L. Ward <mikeyward@gmail.com>'
    sent_on    Time.now
    
    body       :meeting => meeting
  end

  def reminder(meeting)
    subject    "Reminder: CocoaHeads Atlanta meeting is tomorrow"
    recipients 'list@cocoaheadsatlanta.org'
    from       'Michael L. Ward <mikeyward@gmail.com>'
    sent_on    Time.now
    
    body       :meeting => meeting
  end

  protected
  def month_name(meeting)
    meeting.scheduled_at.strftime('%B')
  end
end
