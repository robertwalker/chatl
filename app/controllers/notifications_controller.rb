class NotificationsController < ApplicationController
  before_filter :load_next_upcoming_meeting

  def scheduled
    MeetingMailer.deliver_scheduled(@meeting)
    render :text => "Scheduled meeting message sent.\n"
  end

  def reminder
    MeetingMailer.deliver_reminder(@meeting)
    render :text => "Meeting reminder message sent.\n"
  end

  private
  def load_next_upcoming_meeting
    @meeting = Meeting.next_upcoming
  end
end
