require 'spec_helper'

describe SocialNetwork do
  it "creates a new instance given valid attributes" do
    Factory(:social_network)
  end

  it "provides access to a user" do
    social_network = Factory.build(:social_network)
    social_network.should respond_to(:user)
  end

  it "requires 'network'" do
    social_network = Factory.build(:social_network, :network => nil)
    social_network.should_not be_valid
    social_network.should have(1).errors_on(:network)
  end

  it "requires 'username'" do
    social_network = Factory.build(:social_network, :username => nil)
    social_network.should_not be_valid
    social_network.should have(1).errors_on(:username)
  end
end
