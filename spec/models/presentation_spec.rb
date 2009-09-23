require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Presentation do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :presented_on => Date.today,
      :narrative => "value for narrative"
    }
  end

  it "should create a new instance given valid attributes" do
    Presentation.create!(@valid_attributes)
  end

  it "requires 'title'" do
    presentation = Factory.build(:presentation, :title => nil)
    presentation.should_not be_valid
    presentation.should have(1).errors_on(:title)
  end

  it "requires 'presented_on'" do
    presentation = Factory.build(:presentation, :presented_on => nil)
    presentation.should_not be_valid
    presentation.should have(1).errors_on(:presented_on)
  end

  it "requires 'narrative'" do
    presentation = Factory.build(:presentation, :narrative => nil)
    presentation.should_not be_valid
    presentation.should have(1).errors_on(:narrative)
  end
end
