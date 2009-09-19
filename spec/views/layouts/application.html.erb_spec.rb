require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application" do
  def mock_meeting(stubs={})
    @mock_meeting ||= mock_model(Meeting, stubs)
  end

  before(:each) do
    Meeting.stub!(:upcoming).and_return([ mock_meeting ])
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

  it "should contain the page_wrapper div" do
    response.should have_tag('div#page_wrapper')
  end

  it "should contain the top_spacer div" do
    response.should have_tag('div#top_spacer')
  end

  it "should contain the banner div" do
    response.should have_tag('div#banner') do
      with_tag('a[href=?]', "/") do
        with_tag('img[id=?][src=?]', "chatl_logo", %r{/images/chatl_logo.jpg.*})
      end
    end
  end

  it "should contain the tab bar" do
    response.should have_tag('div#tab_bar') do
      with_tag('div#meetings_tab', "Meetings")
      # with_tag('div#presentations_tab', "Presentations")
      # with_tag('div#files_tab', "Files")
      # with_tag('div#members_tab', "Members")
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
