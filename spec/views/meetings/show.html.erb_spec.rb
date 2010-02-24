require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meetings/show.html.erb" do
  include MeetingsHelper

  before(:each) do
    assigns[:meeting] = @meeting = stub_model(Meeting,
      :venue_id => 1,
      :details => "value for details"
    )
    assigns[:attendee] = @attendee = stub_model(Attendee,
      :user => stub_model(User)
    )
    assigns[:attendees] = @attendees = [ @attendee ]
  end

  it "renders the calendar icon" do
    render
    response.should have_tag('div.calendar_icon')
  end

  it "renders the RSVP panel" do
    render
    response.should have_tag('div#rsvp_panel')
  end

  it "renders the venue details" do
    render
    response.should have_tag('div#venue_details') do
      with_tag('div.layout_labels')
      with_tag('div.layout_fields')
    end
  end

  it "renders the meeting details" do
    render
    response.should have_tag('div#meeting_details') do
    end
  end

  describe "not signed in as an admin" do
    it "hides link for editing meetings" do
      render
      response.should_not have_tag("a[href=?]", %r{/meetings/\d+/edit}, "Edit")
    end
  end

  describe "signed in as a member" do
    before(:each) do
      login_as(Factory(:user))
    end

    it "renders RSVP div" do
      render
      response.should have_tag("div#rsvp_panel")
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

    it "renders link for editing meetings" do
      render
      response.should have_tag("a[href=?]", %r{/meetings/\d+/edit}, "Edit")
    end
  end
end
