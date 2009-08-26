require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meeting do
  def second_thursday_next_month
    wday_map = { 0 => 4, 1 => 3, 2 => 2, 3 => 1, 4 => 0, 5 => 6, 6 => 5 }
    next_month = Time.now.next_month.beginning_of_month.utc
    next_month + wday_map[next_month.wday].days + 1.week + 19.hours
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
    meeting.scheduled_at.should == second_thursday_next_month
  end
end
