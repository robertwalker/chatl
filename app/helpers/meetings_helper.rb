module MeetingsHelper
  def rsvp_state
    current_attendee = @meeting.attendee_with_user(current_user)
    klass = "attendee_rsvp"
    case current_attendee.rsvp
    when "Yes"
      klass << " attendee_rsvp_yes"
    when "No"
      klass << " attendee_rsvp_no"
    when "Maybe"
      klass << " attendee_rsvp_maybe"
    end
    content_tag(:p, current_attendee.rsvp, :class => klass)
  end
end
