require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meetings/show.html.erb" do
  include MeetingsHelper
  before(:each) do
    assigns[:meeting] = @meeting = stub_model(Meeting,
      :venue_id => 1,
      :details => "value for details"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ details/)
  end

  describe "not signed in as an admin" do
    it "hides link for editing meetings" do
      render
      response.should_not have_tag("a[href=?]", %r{/meetings/\d+/edit}, "Edit")
    end
  end

  describe "authenticated as admin" do
    before(:each) do
      admin_role = Factory(:role)
      @admin_user = Factory.build(:user)
      @admin_user.roles << admin_role
      @admin_user.save
      login_as(@admin_user)
    end

    it "renders link for editing meetings" do
      render
      response.should have_tag("a[href=?]", %r{/meetings/\d+/edit}, "Edit")
    end
  end
end
