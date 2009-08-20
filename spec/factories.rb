# The admin role
Factory.define :role do |r|
  r.name 'admin'
end

# A user
Factory.define :user do |u|
  u.login 'a_user'
  u.email 'a_user@example.com'
  u.password 'monkey'
  u.password_confirmation 'monkey'
  u.state 'active'
end

# A regular venue
Factory.define :venue do |v|
  v.name 'Venue name'
  v.street_address 'Venue address'
  v.city 'Atlanta'
  v.state 'GA'
  v.zip '30303'
end
