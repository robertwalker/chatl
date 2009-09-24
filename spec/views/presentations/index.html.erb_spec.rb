require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/presentations/index.html.erb" do
  include PresentationsHelper

  before(:each) do
    assigns[:presentations] = [
      stub_model(Presentation,
        :title => "value for title",
        :presented_on => Date.today,
        :narrative => "value for narrative"
      ),
      stub_model(Presentation,
        :title => "value for title",
        :presented_on => Date.today,
        :narrative => "value for narrative"
      )
    ]
  end

  it "renders a list of presentations" do
    render
    response.should have_tag("div.post_content") do
      with_tag("h2.post_title", "value for title".to_s, 2)
      with_tag("div.post_date_line") do
        with_tag("img[src=?]", %r{/images/date.gif.*})
        with_tag("span.post_date", /.+/)
      end
      with_tag("div.post_narrative", "value for narrative".to_s, 2)
    end
  end

  describe "logged in as an admin" do
    before(:each) do
      admin_role = Factory(:role)
      @admin_user = Factory.build(:user)
      @admin_user.roles << admin_role
      @admin_user.save
      login_as(@admin_user)
    end

    it "renders the row control links" do
      render
      response.should have_tag("div.post_content") do
        # TODO: Refactor this CSS class so it's not referencing meeting
        with_tag("div.meeting_row_controls", 2) do
          with_tag("a[href=?]", %r{/presentations/\d+}, "Show")
          with_tag("a[href=?]", %r{/presentations/\d+/edit}, "Edit")
          with_tag("a[href=?]", %r{/presentations/\d+}, "Destroy")
        end
      end
    end
  end
end
