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
    response.should have_tag("tr>td", "value for comment".to_s, 2)
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for content_type".to_s, 2)
  end
end
