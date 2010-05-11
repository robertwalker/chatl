require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/edit.html.erb" do
  include UsersHelper

  before(:each) do
    assigns[:user] = @user = stub_model(User,
      :new_record? => false,
      :login => "a_user",
      :first_name => "First",
      :last_name => "Last",
      :email => "a_user@example.com",
      :password => "monkey",
      :password_confirmation => "monkey",
      :state => "active",
      :gravatar_url => "http://example.com"
    )
  end

  it "renders the heading" do
    render
    response.should have_tag("h1", "Editing user profile")
  end

  it "renders the edit user form" do
    render
    response.should have_tag("form[action=#{user_path(@user)}][method=post]") do
      # with_tag('input#openid_identifier[name=?][size=?]', "openid_identifier", "50")
      with_tag('input#user_email[name=?]', "user[email]")
      with_tag('input#user_first_name[name=?]', "user[first_name]")
      with_tag('input#user_last_name[name=?]', "user[last_name]")
      with_tag('input#user_subscribe_to_chatter[name=?][type=?]',
               "user[subscribe_to_chatter]", "checkbox")
    end
  end
end
