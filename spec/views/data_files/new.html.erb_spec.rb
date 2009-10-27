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

    response.should have_tag("form[action=?][method=post]", data_files_path) do
      with_tag("input#data_file_comment[name=?]", "data_file[comment]")
      with_tag("input#data_file_name[name=?]", "data_file[name]")
      with_tag("input#data_file_content_type[name=?]", "data_file[content_type]")
    end
  end
end
