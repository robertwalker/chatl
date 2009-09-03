require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttendeesController do
  def mock_meeting(stubs={})
    @mock_meeting ||= mock_model(Meeting, stubs)
  end

  def mock_attendee(stubs={})
    @mock_attendee ||= mock_model(Attendee, stubs)
  end

  describe "with user not logged in" do
    it "denies access to 'create'" do
      post :create, :meeting_id => "1", :attendee => {:these => 'params'}
      response.should redirect_to(new_session_url)
    end

    it "denies access to 'update'" do
      put :update, :id => "1", :meeting_id => "1", :attendee => {:these => 'params'}
      response.should redirect_to(new_session_url)
    end

    it "denies access to 'destroy'" do
      delete :destroy, :id => "1", :meeting_id => "1"
      response.should redirect_to(new_session_url)
    end
  end

  describe "with user logged in" do
    before(:each) do
      @user = Factory(:user)
      login_as(@user)
      Meeting.stub!(:find).with("1").and_return(mock_meeting)
    end

    describe "POST create" do
      it "assigns the associated meeting as @meeting" do
        Attendee.stub!(:new).and_return(mock_attendee(:rsvp => "Yes", :save => true))
        post :create, :meeting_id => "1", :attendee => {:these => 'params'}
        assigns[:meeting].should equal(mock_meeting)
      end

      it "assigns a new attended as @attendee" do
        Attendee.stub!(:new).and_return(mock_attendee(:rsvp => "Yes", :save => true))
        post :create, :meeting_id => "1", :attendee => {:these => 'params'}
        assigns[:attendee].should equal(mock_attendee)
      end

      it "redirects to the associated meeting" do
        Attendee.stub!(:new).and_return(mock_attendee(:rsvp => "Yes", :save => true))
        post :create, :meeting_id => "1", :attendee => {:these => 'params'}
        response.should redirect_to(meeting_url(mock_meeting))
      end

      describe "with valid params" do
        it "displays a flash notice indicating a RSVP of Yes" do
          Attendee.stub!(:new).and_return(mock_attendee(:rsvp => "Yes", :save => true))
          post :create, :meeting_id => "1", :attendee => {:these => 'params'}
          flash[:notice].should == "Thanks! See you there."
        end

        it "displays a flash notice indicating a RSVP of No" do
          Attendee.stub!(:new).and_return(mock_attendee(:rsvp => "No", :save => true))
          post :create, :meeting_id => "1", :attendee => {:these => 'params'}
          flash[:notice].should == "Okay. Hope to see you again soon."
        end

        it "displays a flash notice indicating a RSVP of Maybe" do
          Attendee.stub!(:new).and_return(mock_attendee(:rsvp => "Maybe", :save => true))
          post :create, :meeting_id => "1", :attendee => {:these => 'params'}
          flash[:notice].should == "Thanks. Hope to see you there if your schedule permits."
        end
      end

      describe "with invalid params" do
      end
    end
  end
end
