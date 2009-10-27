require 'spec_helper'

describe "/data_files/show.html.erb" do
  include DataFilesHelper
  before(:each) do
    assigns[:data_file] = @data_file = stub_model(DataFile,
      :comment => "value for comment",
      :name => "value for name",
      :content_type => "value for content_type"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ comment/)
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ content_type/)
  end
end
