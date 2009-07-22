require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application" do
  before(:each) do
    render 'layouts/application'
  end

  it "should contain the 'sidebar' div" do
    response.should have_tag('div#sidebar')
  end
  
  it "should contain the 'main_content' div" do
    response.should have_tag('div#main_content')
  end
end
