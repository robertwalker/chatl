require 'spec_helper'

describe DataFile do
  it "should create a new instance given valid attributes" do
    @data_file = Factory.build(:data_file)
    @data_file.should be_valid
    @data_file.should have(:no).errors
  end

  it "should require 'comment'" do
    @data_file = Factory.build(:data_file, :comment => nil)
    @data_file.should_not be_valid
    @data_file.errors.should_not be_empty
  end

  it "should require 'name'" do
    @data_file = Factory.build(:data_file, :name => nil)
    @data_file.should_not be_valid
    @data_file.errors.should_not be_empty
  end

  it "should require 'content_type'" do
    @data_file = Factory.build(:data_file, :content_type => nil)
    @data_file.should_not be_valid
    @data_file.errors.should_not be_empty
  end
end
