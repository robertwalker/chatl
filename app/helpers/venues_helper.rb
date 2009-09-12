module VenuesHelper
  def map_search_url(venue)
    url = "http://maps.google.com"
    url << "?q=#{CGI.escape(venue.street_address)}" if venue.street_address
    url << ",+#{CGI.escape(venue.city)}" if venue.city
    url << ",+#{CGI.escape(venue.state)}" if venue.state
    url << "+#{CGI.escape(venue.zip)}" if venue.zip
    (venue.map_url.blank?) ? url : venue.map_url
  end

  def map_link(venue)
    link_to_function "(Show on Map)", "window.open('#{map_search_url(venue)}')"
  end
end
