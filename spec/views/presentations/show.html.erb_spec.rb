require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/presentations/show.html.erb" do
  include PresentationsHelper

  before(:each) do
    assigns[:presentation] = @presentation = stub_model(Presentation,
      :title => "value for title",
      :presented_on => Date.today,
      :presented_by => "value for presented_by",
      :narrative => "value for narrative"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_tag("img[src=?][alt=?]", %r{/images/date\.gif.*}, "Date")
    response.should have_text(/Presented\ by\ value\ for\ presented_by/)
    response.should have_text(presented_on_regex)
    response.should have_text(/value\ for\ narrative/)
  end

  def presented_on_regex
    Regexp.new(Date.today.strftime("%A, %B %e, %Y").gsub(/ /, "\ "))
  end
end
