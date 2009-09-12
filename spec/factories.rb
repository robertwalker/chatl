require 'cgi'

# The admin role
Factory.define :role do |f|
  f.name 'admin'
end

# A user
Factory.define :user do |f|
  f.login 'a_user'
  f.email 'a_user@example.com'
  f.password 'monkey'
  f.password_confirmation 'monkey'
  f.state 'active'
end

# A regular venue
Factory.define :venue do |f|
  f.name 'Venue name'
  f.street_address 'Venue address'
  f.city 'Atlanta'
  f.state 'GA'
  f.zip '30303'
  f.map_url 'Venue map URL'
end

# A meeting
Factory.define :meeting do |f|
  def f.default_venue
    @default_venue ||= Factory(:venue)
  end
  f.venue_id { f.default_venue.id }
end

# An Attendee
Factory.define :attendee do |f|
  def f.default_user
    @default_user ||= Factory(:user)
  end
  def f.default_meeting
    @default_meeting ||= Factory(:meeting)
  end
  f.user_id { f.default_user }
  f.meeting_id { f.default_meeting }
  f.rsvp 'Yes'
end
