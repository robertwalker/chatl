require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meetings/new.html.erb" do
  include MeetingsHelper

  before(:each) do
    assigns[:meeting] = stub_model(Meeting,
      :new_record? => true,
      :venue_id => 1,
      :details => "value for details"
    )
  end

  it "renders new meeting form" do
    render

    response.should have_tag("form[action=?][method=post]", meetings_path) do
      with_tag("input#meeting_venue_id[name=?]", "meeting[venue_id]")
      with_tag("textarea#meeting_details[name=?]", "meeting[details]")
    end
  end
end
