require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attendee do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :meeting_id => 1,
      :rsvp => "value for rsvp"
    }
  end

  it "should create a new instance given valid attributes" do
    Attendee.create!(@valid_attributes)
  end

  it "requires 'user_id'" do
    attendee = Factory.build(:attendee, :user_id => nil)
    attendee.should_not be_valid
    attendee.should have(1).errors_on(:user_id)
  end

  it "requires 'meeting_id'" do
    attendee = Factory.build(:attendee, :meeting_id => nil)
    attendee.should_not be_valid
    attendee.should have(1).errors_on(:meeting_id)
  end

  it "belongs to a user" do
    attendee = Factory(:attendee)
    attendee.should respond_to(:user)
  end

  it "belongs to a meeting" do
    attendee = Factory(:attendee)
    attendee.should respond_to(:meeting)
  end

  it "provides access to the RSVP_STATES constant" do
    Attendee::RSVP_STATES.should == %w{ Yes No Maybe }
  end
end
