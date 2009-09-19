require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meetings/index.html.erb" do
  include MeetingsHelper

  before(:each) do
    assigns[:meetings] = [
      stub_model(Meeting,
        :title => "value for title",
        :venue_id => 1,
        :details => "value for details"
      ),
      stub_model(Meeting,
        :title => "value for title",
        :venue_id => 1,
        :details => "value for details"
      )
    ]
    assigns[:upcoming_meetings] = [
      stub_model(Meeting,
        :title => "value for title",
        :venue_id => 1,
        :details => "value for details"
      ),
      stub_model(Meeting,
        :title => "value for title",
        :venue_id => 1,
        :details => "value for details"
      )
    ]
  end

  it "should render 'Past Meetings' header" do
    render
    response.should have_tag("h1", "Past Meetings")
  end

  it "should render the a list of meetings" do
    render
    response.should have_tag("div.meeting_row") do
      with_tag("div.calendar_icon_sm")
      with_tag("div.meeting_row_controls")
      with_tag("div.meeting_row_content")
    end
  end

  describe "with no meetings (the blank state)" do
    before(:each) do
      assigns[:meetings] = @meetings = []
    end

    it "shows blank state image" do
      render
      response.should have_tag("img#blank_state[src=?]", %r{/images/meeting_blank_state.jpg.*})
    end
  end

  describe "not logged in" do
    it "hides link for creating new meetings" do
      render
      response.should_not have_tag("a[href=?]", "/meetings/new")
    end

    it "hides link for editing meetings" do
      render
      response.should_not have_tag("a[href=?]", %r{/meetings/\d+/edit}, "Edit")
    end

    it "hides link for destroying meetings" do
      render
      response.should_not have_tag("a[href=?]", %r{/meetings/\d+}, "Destroy")
    end
  end

  describe "authenticated as admin" do
    before(:each) do
      admin_role = Factory(:role)
      @admin_user = Factory.build(:user)
      @admin_user.roles << admin_role
      @admin_user.save
      login_as(@admin_user)
    end

    it "should render 'Upcoming Meetings header" do
      render
      response.should have_tag("h1", "Upcoming Meetings")
    end

    it "renders a link for creating new meetings" do
      render
      response.should have_tag("a[href=?]", "/meetings/new")
    end

    it "renders a link for creating new meetings" do
      render
      response.should have_tag("a[href=?]", %r{/meetings/\d+/edit}, "Edit")
    end

    it "renders a link for creating new meetings" do
      render
      response.should have_tag("a[href=?]", %r{/meetings/\d+}, "Destroy")
    end
  end
end
