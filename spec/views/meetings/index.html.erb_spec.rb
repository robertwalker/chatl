require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/meetings/index.html.erb" do
  include MeetingsHelper

  before(:each) do
    assigns[:meetings] = [
      stub_model(Meeting,
        :venue_id => 1,
        :details => "value for details"
      ),
      stub_model(Meeting,
        :venue_id => 1,
        :details => "value for details"
      )
    ]
  end

  describe "not signed in as an admin" do
    it "hides link for creating new meetings" do
      render
      response.should_not have_tag("a[href=?]", "/meetings/new")
    end

    it "hides link for editing meetings" do
      render
      response.should_not have_tag("a[href=?]", %r{/meetings/\d+/edit}, "Edit")
    end

    it "hides link for destroying meetings" do
      render
      response.should_not have_tag("a[href=?]", %r{/meetings/\d+}, "Destroy")
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

    it "renders a link for creating new meetings" do
      render
      response.should have_tag("a[href=?]", "/meetings/new")
    end

    it "renders a link for creating new meetings" do
      render
      response.should have_tag("a[href=?]", %r{/meetings/\d+/edit}, "Edit")
    end

    it "renders a link for creating new meetings" do
      render
      response.should have_tag("a[href=?]", %r{/meetings/\d+}, "Destroy")
    end
  end
end
