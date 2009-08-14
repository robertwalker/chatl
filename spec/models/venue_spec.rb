require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Venue do
  it "should create a new instance given valid attributes" do
    @venue = Factory.build(:venue)
    @venue.should be_valid
    @venue.should have(:no).errors
  end

  it "should require 'name'" do
    @venue = Factory.build(:venue, :name => nil)
    @venue.should_not be_valid
    @venue.errors.should_not be_empty
  end

  it "should require 'street_address'" do
    @venue = Factory.build(:venue, :street_address => nil)
    @venue.should_not be_valid
    @venue.errors.should_not be_empty
  end

  it "should require 'city'" do
    @venue = Factory.build(:venue, :city => nil)
    @venue.should_not be_valid
    @venue.errors.should_not be_empty
  end

  it "should require 'state'" do
    @venue = Factory.build(:venue, :state => nil)
    @venue.should_not be_valid
    @venue.errors.should_not be_empty
  end

  it "should require 'zip'" do
    @venue = Factory.build(:venue, :zip => nil)
    @venue.should_not be_valid
    @venue.errors.should_not be_empty
  end

  it "should require 'state' to be two characters" do
    @venue = Factory.build(:venue, :state => "invalid")
    @venue.should_not be_valid
    @venue.errors.should_not be_empty
  end

  it "should force 'state' to be uppercase" do
    @venue = Factory.create(:venue, :state => "ga")
    @venue.state.should == "GA"
  end

  it "should require seating_capacity to be an integer" do
    @venue = Factory.build(:venue, :seating_capacity => "aaa")
    @venue.should_not be_valid
    @venue.errors.should_not be_empty
  end
end
