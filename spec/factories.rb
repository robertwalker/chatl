require 'cgi'

# The admin role
Factory.define :role do |f|
  f.name 'admin'
end

# A user
Factory.define :user do |f|
  f.identity_url 'http://user.example.com/'
  f.login 'a_user'
  f.first_name 'First'
  f.last_name 'Last'
  f.email 'a_user@example.com'
  f.password 'monkey'
  f.password_confirmation 'monkey'
  f.state 'active'
  f.logged_in_at Time.now
end

# Another user
Factory.define :steve, :class => User do |f|
  f.identity_url 'http://steve.example.com/'
  f.login 'steve'
  f.first_name 'Steve'
  f.last_name 'Smith'
  f.email 'steve@example.com'
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
  f.title "Meeting title"
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

# A Presentation
Factory.define :presentation do |f|
  f.title 'Presentation title'
  f.presented_on Date.today
  f.presented_by 'Presenation presented_by'
  f.narrative 'Presentation narrative'
end

# A Data File
Factory.define :data_file do |f|
  f.comment 'DataFile comment'
  f.name 'DataFile name'
  f.content_type 'DataFile content_type'
end

# A Social Network
Factory.define :social_network do |f|
  def f.default_user
    @default_user ||= Factory(:user)
  end
  f.user_id { f.default_user }
  f.network "SocialNetwork network"
  f.username "SocialNetwork username"
end
