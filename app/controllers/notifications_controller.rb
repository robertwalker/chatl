class NotificationsController < ApplicationController
  def scheduled
    @meeting = Meeting.next_upcoming
    MeetingMailer.deliver_scheduled(@meeting)
    render :text => "Scheduled meeting message sent.\n"
  end

  def reminder
    render :text => "Meeting reminder message sent.\n"
  end
end
