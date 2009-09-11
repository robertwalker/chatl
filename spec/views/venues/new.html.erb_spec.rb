require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/venues/new.html.erb" do
  include VenuesHelper

  before(:each) do
    assigns[:venue] = stub_model(Venue,
      :new_record? => true,
      :name => "value for name",
      :street_address => "value for street_address",
      :city => "value for city",
      :state => "value for state",
      :zip => "value for zip",
      :seating_capacity => 1,
      :notes => "value for notes"
    )
  end

  it "renders new venue form" do
    render

    response.should have_tag("form[action=?][method=post]", venues_path) do
      with_tag("input#venue_name[name=?]", "venue[name]")
      with_tag('textarea#venue_street_address[name=?]', "venue[street_address]")
      with_tag("input#venue_city[name=?]", "venue[city]")
      with_tag("input#venue_state[name=?]", "venue[state]")
      with_tag("input#venue_zip[name=?]", "venue[zip]")
      with_tag("input#venue_seating_capacity[name=?]", "venue[seating_capacity]")
      with_tag("textarea#venue_notes[name=?]", "venue[notes]")
      with_tag("input#venue_submit[type=?][value=?]", "submit", "Create")
    end
  end
end
