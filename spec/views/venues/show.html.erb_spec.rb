require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/venues/show.html.erb" do
  include VenuesHelper
  before(:each) do
    assigns[:venue] = @venue = stub_model(Venue,
      :name => "value for name",
      :street_address => "value for street_address",
      :city => "value for city",
      :state => "value for state",
      :zip => "value for zip",
      :seating_capacity => 1,
      :notes => "value for notes"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ street_address/)
    response.should have_text(/value\ for\ city/)
    response.should have_text(/value\ for\ state/)
    response.should have_text(/value\ for\ zip/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ notes/)
  end
end
