require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meeting do
  def time_at_wnum_wday_hour(wnum = 2, wday = 4, hour_of_day = 24, min_of_hour = 0)
    offsets = [ 6, 5, 4, 3, 2, 1, 0].rotate(wday + 1)
    first = Time.now.utc.next_month.beginning_of_month
    first + offsets[first.wday].days + (wnum - 1).week + hour_of_day.hours + min_of_hour.minutes
  end

  before(:each) do
    @valid_attributes = {
      :venue_id => 1,
      :scheduled_at => Time.now,
      :details => "value for details"
    }
  end

  it "should create a new instance given valid attributes" do
    meeting = Factory(:meeting)
    meeting.should be_valid
    meeting.should have(:no).errors
  end

  it "requires a title" do
    meeting = Factory.build(:meeting, :title => nil)
    meeting.should_not be_valid
    meeting.should have(1).errors_on(:title)
  end

  it "requires a venue" do
    meeting = Factory.build(:meeting, :venue => nil)
    meeting.should_not be_valid
    meeting.should have(1).errors_on(:venue_id)
  end

  it "requires scheduled date and time" do
    meeting = Factory.build(:meeting, :scheduled_at => nil)
    meeting.should_not be_valid
    meeting.should have(1).errors_on(:scheduled_at)
  end

  it "requires details" do
    meeting = Factory.build(:meeting, :details => nil)
    meeting.should_not be_valid
    meeting.should have(1).errors_on(:details)
  end

  it "defaults scheduled_at to second Thursday of next month at 7 p.m. EST" do
    meeting = Factory(:meeting)
    meeting.scheduled_at.should == time_at_wnum_wday_hour
  end

  it "defaults meeting details to a predefined Textile template" do
    details_template = <<TEMPLATE
h2. Presentation topics

* *Topic 1* - Presented by [member_name]
* *Topic 2* - Presented by [member_name]

h2. After meeting socializing

Join us for drinks and conversion at [venue].
TEMPLATE
    meeting = Factory(:meeting)
    meeting.details.should == details_template
  end

  it "maintains a list of users through attendees" do
    meeting = Factory(:meeting)
    meeting.should respond_to(:attendees)
    meeting.should respond_to(:users)
  end

  it "responds to 'attendee_with_user'" do
    # FIXME: This spec could probably be cleaned up
    meeting = Factory(:meeting)
    user = Factory(:user)
    meeting.attendees.create(:user_id => user.id, :rsvp => "Yes")
    meeting.reload
    meeting.should respond_to(:attendee_with_user)
    meeting.attendee_with_user(user).should == meeting.attendees.first
  end

  it "should provide the next upcoming meeting" do
    meeting = Factory(:meeting)
    Meeting.next_upcoming.should == meeting
  end

  describe "named scopes" do
    it "should have 'recent_past'" do
      Meeting.should respond_to(:recent_past)
    end

    it "should have 'upcoming'" do
      Meeting.should respond_to(:upcoming)
    end
  end
end
