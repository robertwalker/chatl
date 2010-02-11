require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NotificationsController do
  describe "route generation" do
    it "maps #scheduled" do
      route_for(:controller => "notifications", :action => "scheduled").should == { :path => "/notify/scheduled", :method => :post }
    end

    it "maps #reminder" do
      route_for(:controller => "notifications", :action => "reminder").should == { :path => "/notify/reminder", :method => :post }
    end
  end

  describe "route recognition" do
    it "generates params for #scheduled" do
      params_from(:post, "/notify/scheduled").should == {:controller => "notifications", :action => "scheduled"}
    end

    it "generates params for #reminder" do
      params_from(:post, "/notify/reminder").should == {:controller => "notifications", :action => "reminder"}
    end
  end
end
