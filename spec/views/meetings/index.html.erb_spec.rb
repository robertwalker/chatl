require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meetings/index.html.erb" do
  include MeetingsHelper

  before(:each) do
    assigns[:meetings] = [
      stub_model(Meeting,
        :venue_id => 1,
        :details => "value for details"
      ),
      stub_model(Meeting,
        :venue_id => 1,
        :details => "value for details"
      )
    ]
  end

  it "renders a list of meetings" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for details".to_s, 2)
  end
end
