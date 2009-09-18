require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeetingsController do

  def mock_meeting(stubs = {})
    @mock_meeting ||= mock_model(Meeting, stubs)
  end

  def mock_attendee(stubs = {})
    @mock_attendee ||= mock_model(Attendee, stubs)
  end

  describe "GET index" do
    it "assigns recent past meetings as @meetings" do
      Meeting.stub!(:recent_past).and_return([mock_meeting])
      mock_meeting.stub!(:attendee_with_user).and_return(nil)
      get :index
      assigns[:meetings].should == [mock_meeting]
    end
  end

  describe "GET show" do
    it "assigns the requested meeting as @meeting" do
      Meeting.stub!(:find).with("37").and_return(mock_meeting)
      mock_meeting.stub!(:attendee_with_user).and_return(nil)
      get :show, :id => "37"
      assigns[:meeting].should equal(mock_meeting)
    end

    it "assigns a new attendee as @attendee" do
      Meeting.stub!(:find).with("37").and_return(mock_meeting)
      Attendee.stub!(:new).and_return(mock_attendee)
      mock_meeting.stub!(:attendee_with_user).and_return(nil)
      get :show, :id => "37"
      assigns[:attendee].should equal(mock_attendee)
    end
  end

  describe "GET next_scheduled" do
    it "assigns next scheduled meeting as @meeting" do
      Meeting.stub!(:next_scheduled).and_return([ mock_meeting ])
      mock_meeting.stub!(:attendee_with_user).and_return(nil)
      get :next_scheduled
      assigns[:meeting].should equal(mock_meeting)
    end

    it "renders show template for @meeting" do
      Meeting.stub!(:next_scheduled).and_return([ mock_meeting ])
      mock_meeting.stub!(:attendee_with_user).and_return(nil)
      get :next_scheduled
      response.should render_template("meetings/show")
    end
  end

  describe "not logged in" do
    it "denies access to 'new'" do
      get :new
      response.should redirect_to(new_session_url)
    end

    it "denies access to 'edit'" do
      get :edit, :id => "1"
      response.should redirect_to(new_session_url)
    end

    it "denies access to 'create'" do
      post :create, :venue => {:these => 'params'}
      response.should redirect_to(new_session_url)
    end

    it "denies access to 'update'" do
      put :update, :id => "37", :venue => {:these => 'params'}
      response.should redirect_to(new_session_url)
    end

    it "denies access to 'destroy'" do
      delete :destroy, :id => "1"
      response.should redirect_to(new_session_url)
    end
  end

  describe "authenticated but not authorized" do
    before(:each) do
      login_as(Factory(:user))
    end

    it "denies access to 'new'" do
      get :new
      response.should have_text("You don't have access here.")
    end

    it "denies access to 'edit'" do
      get :edit, :id => "1"
      response.should have_text("You don't have access here.")
    end

    it "denies access to 'create'" do
      post :create, :venue => {:these => 'params'}
      response.should have_text("You don't have access here.")
    end

    it "denies access to 'update'" do
      put :update, :id => "37", :venue => {:these => 'params'}
      response.should have_text("You don't have access here.")
    end

    it "denies access to 'destroy'" do
      delete :destroy, :id => "1"
      response.should have_text("You don't have access here.")
    end
  end

  describe "authenticated and authorized as admin" do
    before(:each) do
      admin_role = Factory(:role)
      @admin_user = Factory.build(:user)
      @admin_user.roles << admin_role
      @admin_user.save
      login_as(@admin_user)
    end

    describe "GET index" do
      it "assigns upcoming meetings as @upcoming_meetings" do
        Meeting.stub!(:recent_past).and_return([mock_meeting])
        Meeting.should_receive(:upcoming).and_return([mock_meeting])
        mock_meeting.stub!(:attendee_with_user).and_return(nil)
        get :index
        assigns[:upcoming_meetings].should == [mock_meeting]
      end
    end

    describe "GET new" do
      it "assigns a new meeting as @meeting" do
        Meeting.stub!(:new).and_return(mock_meeting)
        get :new
        assigns[:meeting].should equal(mock_meeting)
      end
    end

    describe "GET edit" do
      it "assigns the requested meeting as @meeting" do
        Meeting.stub!(:find).with("37").and_return(mock_meeting)
        get :edit, :id => "37"
        assigns[:meeting].should equal(mock_meeting)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "assigns a newly created meeting as @meeting" do
          Meeting.stub!(:new).with({'these' => 'params'}).and_return(mock_meeting(:save => true))
          post :create, :meeting => {:these => 'params'}
          assigns[:meeting].should equal(mock_meeting)
        end

        it "redirects to the created meeting" do
          Meeting.stub!(:new).and_return(mock_meeting(:save => true))
          post :create, :meeting => {}
          response.should redirect_to(meeting_url(mock_meeting))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved meeting as @meeting" do
          Meeting.stub!(:new).with({'these' => 'params'}).and_return(mock_meeting(:save => false))
          post :create, :meeting => {:these => 'params'}
          assigns[:meeting].should equal(mock_meeting)
        end

        it "re-renders the 'new' template" do
          Meeting.stub!(:new).and_return(mock_meeting(:save => false))
          post :create, :meeting => {}
          response.should render_template('new')
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested meeting" do
          Meeting.should_receive(:find).with("37").and_return(mock_meeting)
          mock_meeting.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :meeting => {:these => 'params'}
        end

        it "assigns the requested meeting as @meeting" do
          Meeting.stub!(:find).and_return(mock_meeting(:update_attributes => true))
          put :update, :id => "1"
          assigns[:meeting].should equal(mock_meeting)
        end

        it "redirects to the meeting" do
          Meeting.stub!(:find).and_return(mock_meeting(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(meeting_url(mock_meeting))
        end
      end

      describe "with invalid params" do
        it "updates the requested meeting" do
          Meeting.should_receive(:find).with("37").and_return(mock_meeting)
          mock_meeting.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :meeting => {:these => 'params'}
        end

        it "assigns the meeting as @meeting" do
          Meeting.stub!(:find).and_return(mock_meeting(:update_attributes => false))
          put :update, :id => "1"
          assigns[:meeting].should equal(mock_meeting)
        end

        it "re-renders the 'edit' template" do
          Meeting.stub!(:find).and_return(mock_meeting(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested meeting" do
        Meeting.should_receive(:find).with("37").and_return(mock_meeting)
        mock_meeting.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the meetings list" do
        Meeting.stub!(:find).and_return(mock_meeting(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(meetings_url)
      end
    end

    describe "GET next_scheduled" do
      it "assigns upcoming meetings as @upcoming_meetings" do
        Meeting.stub!(:recent_past).and_return([mock_meeting])
        Meeting.should_receive(:upcoming).and_return([mock_meeting])
        mock_meeting.stub!(:attendee_with_user).and_return(nil)
        get :next_scheduled
        assigns[:upcoming_meetings].should == [mock_meeting]
      end
    end
  end
end
