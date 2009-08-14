require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VenuesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "venues", :action => "index").should == "/venues"
    end

    it "maps #new" do
      route_for(:controller => "venues", :action => "new").should == "/venues/new"
    end

    it "maps #show" do
      route_for(:controller => "venues", :action => "show", :id => "1").should == "/venues/1"
    end

    it "maps #edit" do
      route_for(:controller => "venues", :action => "edit", :id => "1").should == "/venues/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "venues", :action => "create").should == {:path => "/venues", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "venues", :action => "update", :id => "1").should == {:path =>"/venues/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "venues", :action => "destroy", :id => "1").should == {:path =>"/venues/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/venues").should == {:controller => "venues", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/venues/new").should == {:controller => "venues", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/venues").should == {:controller => "venues", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/venues/1").should == {:controller => "venues", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/venues/1/edit").should == {:controller => "venues", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/venues/1").should == {:controller => "venues", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/venues/1").should == {:controller => "venues", :action => "destroy", :id => "1"}
    end
  end
end
