require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/presentations/new.html.erb" do
  include PresentationsHelper

  before(:each) do
    assigns[:presentation] = stub_model(Presentation,
      :new_record? => true,
      :title => "value for title",
      :narrative => "value for narrative"
    )
  end

  it "renders new presentation form" do
    render

    response.should have_tag("form[action=?][method=post]", presentations_path) do
      with_tag("input#presentation_title[name=?]", "presentation[title]")
      with_tag("textarea#presentation_narrative[name=?]", "presentation[narrative]")
    end
  end
end
