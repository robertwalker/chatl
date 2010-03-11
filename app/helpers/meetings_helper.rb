module MeetingsHelper
  def rsvp_state
    current_attendee = @meeting.attendee_with_user(current_user)
    klass = rsvp_state_style(current_attendee.rsvp)
    content_tag(:p, current_attendee.rsvp, :class => klass)
  end

  def meeting_attendance
    yes_rsvps = @meeting.attendees.find_all_by_rsvp("Yes")
    no_rsvps = @meeting.attendees.find_all_by_rsvp("No")
    maybe_rsvps = @meeting.attendees.find_all_by_rsvp("Maybe")

    content_tag(:p, "#{yes_rsvps.count} Yes", :class => rsvp_state_style("Yes")) +
    content_tag(:p) do
      content_tag(:span, "#{no_rsvps.count} No", :class => "attendee_rsvp_no") +
      content_tag(:span, " / ") +
      content_tag(:span, "#{maybe_rsvps.count} Maybe", :class => "attendee_rsvp_maybe")
    end
  end

  def feed_summary(meeting)
    summary = "What: " + meeting.title
    summary << "\nWhen: " + meeting.scheduled_at.strftime("%A, %B %d, %Y %I:%M %p")
    summary << "\nWhere: " + meeting.venue.name
  end

  protected

  def rsvp_state_style(rsvp)
    klass = "attendee_rsvp"
    case rsvp
    when "Yes"
      klass << " attendee_rsvp_yes"
    when "No"
      klass << " attendee_rsvp_no"
    when "Maybe"
      klass << " attendee_rsvp_maybe"
    end
  end
end
