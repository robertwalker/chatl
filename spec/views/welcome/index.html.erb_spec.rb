require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/welcome/index" do
  before(:each) do
    render 'welcome/index'
  end

  it "should contain the 'sidebar' div" do
    response.should have_tag('div#sidebar')
  end
  
  it "should contain the 'blog_post_container' div" do
    response.should have_tag('div#blog_post_container') do
      with_tag('div.post_content') do
        with_tag('h2.post_title')
        with_tag('div.post_date_line')
        with_tag('div.post_narrative')
      end
    end
  end
end
