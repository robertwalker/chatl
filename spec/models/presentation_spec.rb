require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Presentation do
  it "should create a new instance given valid attributes" do
    presentation = Factory.build(:presentation)
    presentation.should be_valid
    presentation.should have(:no).errors
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

  it "requires 'presented_by'" do
    presentation = Factory.build(:presentation, :presented_by => nil)
    presentation.should_not be_valid
    presentation.should have(1).errors_on(:presented_by)
  end

  it "requires 'narrative'" do
    presentation = Factory.build(:presentation, :narrative => nil)
    presentation.should_not be_valid
    presentation.should have(1).errors_on(:narrative)
  end
end
