require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/presentations/show.html.erb" do
  include PresentationsHelper
  before(:each) do
    assigns[:presentation] = @presentation = stub_model(Presentation,
      :title => "value for title",
      :narrative => "value for narrative"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ narrative/)
  end
end
