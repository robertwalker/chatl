require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/index.html.erb" do
  include UsersHelper

  before(:each) do
    assigns[:users] = [
      stub_model(User,
        :login => "a_user",
        :email => "a_user@example.com",
        :password => "monkey",
        :password_confirmation => "monkey",
        :state => "active"
      ),
      stub_model(User,
      :login => "a_user",
      :email => "a_user@example.com",
      :password => "monkey",
      :password_confirmation => "monkey",
      :state => "active"
      )
    ]
  end

  it 'renders a list of users (members)' do
    render
    response.should have_tag("div.user_row", 2) do
      with_tag("div.gravatar_image") do
        with_tag("img[alt=?][width=?][height=?]", "Gravatar image", "48", "48")
      end
      with_tag("div.row_controls")
      # with_tag("div.data_file_row_icon")
      # with_tag("div.data_file_row_content") do
      #   with_tag("div.data_file_row_title")
      #   with_tag("div.data_file_row_date")
      #   with_tag("div.data_file_row_name")
      # end
    end
  end
end
