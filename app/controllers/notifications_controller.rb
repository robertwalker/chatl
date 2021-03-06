class NotificationsController < ApplicationController
  before_filter :load_next_upcoming_meeting

  def scheduled
    if @meeting
      MeetingMailer.deliver_scheduled(@meeting)
      render :text => "Scheduled meeting message sent.\n"
    else
      render :text => "No scheduled meeting found for notification.\n"
    end
  end

  def reminder
    if @meeting && @meeting.send_notification?
      MeetingMailer.deliver_reminder(@meeting)
      @meeting.update_notification_sent
      render :text => "Meeting reminder message sent.\n"
    else
      render :text => "No meeting due for notification.\n"
    end
  end

  private
  def load_next_upcoming_meeting
    @meeting = Meeting.next_upcoming
  end
end
