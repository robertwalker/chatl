require 'spec_helper'

describe "/data_files/index.html.erb" do
  include DataFilesHelper

  before(:each) do
    assigns[:data_files] = [
      stub_model(DataFile,
        :comment => "value for comment",
        :name => "value for name",
        :content_type => "value for content_type"
      ),
      stub_model(DataFile,
        :comment => "value for comment",
        :name => "value for name",
        :content_type => "value for content_type"
      )
    ]
  end

  it "renders a list of data_files" do
    render
    response.should have_tag("div.data_file_row", 2) do
      with_tag("div.row_controls")
      with_tag("div.data_file_row_icon")
      with_tag("div.data_file_row_content") do
        with_tag("div.data_file_row_title")
        with_tag("div.data_file_row_date")
        with_tag("div.data_file_row_name")
      end
    end
  end

  it "renders download data_file link" do
    render
    response.should_not have_tag("a[href=?]", %r{/data_files/\d+}, "Download")
  end

  it "should not render edit data_file link" do
    render
    response.should_not have_tag("a[href=?]", %r{/data_files/\d+/edit}, "Edit")
  end

  it "should not render destroy link" do
    render
    response.should_not have_tag("a[href=?]", %r{/data_files/\d+}, "Destroy")
  end

  it "should not render new data_file link" do
    render
    response.should_not have_tag("a[href=?]", "/data_files/new")
  end

  describe "logged in as an admin" do
    before(:each) do
      admin_role = Factory(:role)
      @admin_user = Factory.build(:user)
      @admin_user.roles << admin_role
      @admin_user.save
      login_as(@admin_user)
    end

    it "renders edit data_file link" do
      render
      response.should have_tag("a[href=?]", %r{/data_files/\d+/edit}, "Edit")
    end

    it "renders destroy link" do
      render
      response.should have_tag("a[href=?]", %r{/data_files/\d+}, "Destroy")
    end

    it "renders new data_file link" do
      render
      response.should have_tag("a[href=?]", "/data_files/new", "Upload File")
    end

    it "renders new data file link" do
      render
      response.should have_tag("a[href=?]", "/data_files/new")
    end
  end
end
