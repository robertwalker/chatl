require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Venue do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :street_address => "value for street_address",
      :city => "value for city",
      :state => "value for state",
      :zip => "value for zip",
      :seating_capacity => 1,
      :notes => "value for notes"
    }
  end

  it "should create a new instance given valid attributes" do
    Venue.create!(@valid_attributes)
  end
end
