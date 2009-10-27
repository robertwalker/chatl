require 'spec_helper'

describe DataFilesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/data_files" }.should route_to(:controller => "data_files", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/data_files/new" }.should route_to(:controller => "data_files", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/data_files/1" }.should route_to(:controller => "data_files", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/data_files/1/edit" }.should route_to(:controller => "data_files", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/data_files" }.should route_to(:controller => "data_files", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/data_files/1" }.should route_to(:controller => "data_files", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/data_files/1" }.should route_to(:controller => "data_files", :action => "destroy", :id => "1") 
    end
  end
end
