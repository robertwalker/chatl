require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attendee do
  it "should create a new instance given valid attributes" do
    attendee = Factory.build(:attendee)
    attendee.should be_valid
    attendee.should have(:no).errors
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

  it "requires 'rsvp'" do
    attendee = Factory.build(:attendee, :rsvp => nil)
    attendee.should_not be_valid
    attendee.should have(1).errors_on(:rsvp)
  end

  it "requires 'rsvp' to be one of Yes, No or Maybe" do
    attendee = Factory.build(:attendee, :rsvp => "Invalid")
    valid_values = %w{ Yes No Maybe }
    attendee.should_not be_valid
    attendee.should have(1).errors_on(:rsvp)
    attendee.errors.on(:rsvp).should == "must be Yes, No or Maybe"
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
