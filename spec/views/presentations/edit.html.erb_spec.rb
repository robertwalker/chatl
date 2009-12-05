require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/presentations/edit.html.erb" do
  include PresentationsHelper

  before(:each) do
    assigns[:presentation] = @presentation = stub_model(Presentation,
      :new_record? => false,
      :title => "value for title",
      :narrative => "value for narrative"
    )
  end

  it "renders the edit presentation form" do
    render

    response.should have_tag("form[action=#{presentation_path(@presentation)}][method=post]") do
      with_tag('input#presentation_title[name=?]', "presentation[title]")
      with_tag("select#presentation_presented_on_1i[name=?]", "presentation[presented_on(1i)]")
      with_tag("select#presentation_presented_on_2i[name=?]", "presentation[presented_on(2i)]")
      with_tag("select#presentation_presented_on_3i[name=?]", "presentation[presented_on(3i)]")
      with_tag("input#presentation_presented_by[name=?]", "presentation[presented_by]")
      with_tag('textarea#presentation_narrative[name=?]', "presentation[narrative]")
    end
  end
end
