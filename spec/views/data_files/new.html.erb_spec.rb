require 'spec_helper'

describe "/data_files/new.html.erb" do
  include DataFilesHelper

  before(:each) do
    assigns[:data_file] = stub_model(DataFile,
      :new_record? => true,
      :comment => "value for comment",
      :name => "value for name",
      :content_type => "value for content_type"
    )
  end

  it "renders new data_file form" do
    render

    response.should have_tag("form[action=?][enctype=?][method=post]", data_files_path, "multipart/form-data") do
      with_tag("input#data_file_comment[name=?]", "data_file[comment]")
      with_tag("input#data_file_uploaded_file[name=?][type=file]", "data_file[uploaded_file]")
    end
  end
end
