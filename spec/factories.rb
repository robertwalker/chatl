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
end

# A meeting
Factory.define :meeting do |f|
  f.details "value for details"
  def f.default_venue
    @default_venue ||= Factory(:venue)
  end
  f.venue_id { f.default_venue.id }
end
