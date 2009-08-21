require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meetings/show.html.erb" do
  include MeetingsHelper
  before(:each) do
    assigns[:meeting] = @meeting = stub_model(Meeting,
      :venue_id => 1,
      :details => "value for details"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ details/)
  end
end
