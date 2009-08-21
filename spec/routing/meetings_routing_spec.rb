require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeetingsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "meetings", :action => "index").should == "/meetings"
    end

    it "maps #new" do
      route_for(:controller => "meetings", :action => "new").should == "/meetings/new"
    end

    it "maps #show" do
      route_for(:controller => "meetings", :action => "show", :id => "1").should == "/meetings/1"
    end

    it "maps #edit" do
      route_for(:controller => "meetings", :action => "edit", :id => "1").should == "/meetings/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "meetings", :action => "create").should == {:path => "/meetings", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "meetings", :action => "update", :id => "1").should == {:path =>"/meetings/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "meetings", :action => "destroy", :id => "1").should == {:path =>"/meetings/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/meetings").should == {:controller => "meetings", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/meetings/new").should == {:controller => "meetings", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/meetings").should == {:controller => "meetings", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/meetings/1").should == {:controller => "meetings", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/meetings/1/edit").should == {:controller => "meetings", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/meetings/1").should == {:controller => "meetings", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/meetings/1").should == {:controller => "meetings", :action => "destroy", :id => "1"}
    end
  end
end
