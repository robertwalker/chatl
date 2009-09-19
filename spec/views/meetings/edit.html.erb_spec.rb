require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meetings/edit.html.erb" do
  include MeetingsHelper

  before(:each) do
    assigns[:meeting] = @meeting = stub_model(Meeting,
      :new_record? => false,
      :venue_id => 1,
      :details => "value for details"
    )
  end

  it "renders the edit meeting form" do
    render

    response.should have_tag("form[action=#{meeting_path(@meeting)}][method=post]") do
      with_tag("input#meeting_title[name=?]", "meeting[title]")
      with_tag("select#meeting_venue_id[name=?]", "meeting[venue_id]")
      with_tag('textarea#meeting_details[name=?]', "meeting[details]")
    end
  end
end
