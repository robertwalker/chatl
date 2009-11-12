require 'spec_helper'

describe "/data_files/edit.html.erb" do
  include DataFilesHelper

  before(:each) do
    assigns[:data_file] = @data_file = stub_model(DataFile,
      :new_record? => false,
      :comment => "value for comment",
      :name => "value for name",
      :content_type => "value for content_type"
    )
  end

  it "renders the edit data_file form" do
    render

    response.should have_tag("form[action=#{data_file_path(@data_file)}][method=post]") do
      with_tag('input#data_file_comment[name=?]', "data_file[comment]")
    end
  end
end
