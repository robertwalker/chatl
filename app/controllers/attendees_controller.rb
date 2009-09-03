class AttendeesController < ApplicationController
  before_filter :login_required
  before_filter :load_meeting

  def create
    @attendee = Attendee.new(:meeting_id => @meeting.id,
                             :user_id => current_user.id,
                             :rsvp => params[:attendee][:rsvp])
    if @attendee.save
      flash[:notice] = flash_for_rsvp(@attendee.rsvp)
    else
      flash[:notice] = "Failed to sign up for meeting."
    end
    redirect_to(@meeting)
  end

  def destroy
    @attendee = @meeting.users.delete(current_user)
    redirect_to(@meeting)
  end

  protected

  def load_meeting
    @meeting = Meeting.find(params[:meeting_id])
  end
  
  def flash_for_rsvp(rsvp)
    case rsvp
    when "Yes"
      "Thanks! See you there."
    when "No"
      "Okay. Hope to see you again soon."
    when "Maybe"
      "Thanks. Hope to see you there if your schedule permits."
    end
  end
end
