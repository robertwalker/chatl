require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/venues/index.html.erb" do
  include VenuesHelper

  before(:each) do
    assigns[:venues] = [
      stub_model(Venue,
        :name => "value for name",
        :street_address => "value for street_address",
        :city => "value for city",
        :state => "value for state",
        :zip => "value for zip",
        :seating_capacity => 1,
        :notes => "value for notes"
      ),
      stub_model(Venue,
        :name => "value for name",
        :street_address => "value for street_address",
        :city => "value for city",
        :state => "value for state",
        :zip => "value for zip",
        :seating_capacity => 1,
        :notes => "value for notes"
      )
    ]
  end

  it "renders a list of venues" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for street_address".to_s, 2)
    response.should have_tag("tr>td", "value for city".to_s, 2)
    response.should have_tag("tr>td", "value for state".to_s, 2)
    response.should have_tag("tr>td", "value for zip".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for notes".to_s, 2)
  end
end
