#
# Venues
#

# A regular venue
Factory.define :venue do |v|
  v.name 'Venue name'
  v.street_address 'Venue address'
  v.city 'Atlanta'
  v.state 'GA'
  v.zip '30303'
end
