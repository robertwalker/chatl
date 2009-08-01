require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application" do
  before(:each) do
    render 'layouts/application'
  end

  it "should contain the 'html' tag" do
    response.should have_tag('html[xmlns=?][xml:lang=?][lang=?]',
                             "http://www.w3.org/1999/xhtml", "en", "en")
  end

  it "should contain the head tag" do
    response.should have_tag('head') do
      with_tag('meta[http-equiv=?][content=?]', "Content-Type", "text/html; charset=utf-8")
      with_tag('title', /^Cocoaheads Atlanta.*/)
    end
  end

  it "should contain the body tag" do
    response.should have_tag('body')
  end

  it "should contain the banner div" do
    response.should have_tag('div#banner') do
      with_tag('a[href=?]', "/") do
        with_tag('img[id=?][src=?]', "chatl_logo", %r{/images/chatl_logo.jpg.*})
      end
    end
  end

  it "should contain the 'sidebar' div" do
    response.should have_tag('div#sidebar')
  end

  it "should contain the 'main_content' div" do
    response.should have_tag('div#main_content')
  end
  
  it "should contain the 'footer' div" do
    response.should have_tag('div#footer')
  end
end
