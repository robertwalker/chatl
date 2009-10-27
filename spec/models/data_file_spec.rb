require 'spec_helper'

describe DataFile do
  before(:each) do
    @valid_attributes = {
      :comment => "value for comment",
      :name => "value for name",
      :content_type => "value for content_type"
    }
  end

  it "should create a new instance given valid attributes" do
    DataFile.create!(@valid_attributes)
  end
end
