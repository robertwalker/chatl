require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/presentations/index.html.erb" do
  include PresentationsHelper

  before(:each) do
    assigns[:presentations] = [
      stub_model(Presentation,
        :title => "value for title",
        :narrative => "value for narrative"
      ),
      stub_model(Presentation,
        :title => "value for title",
        :narrative => "value for narrative"
      )
    ]
  end

  it "renders a list of presentations" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for narrative".to_s, 2)
  end
end
