require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VenuesController do

  def mock_venue(stubs={})
    @mock_venue ||= mock_model(Venue, stubs)
  end

  describe "not logged in" do
    it "denies access to 'index'" do
      get :index
      response.should redirect_to(new_session_url)
    end

    it "denies access to 'show'" do
      get :show, :id => "1"
      response.should redirect_to(new_session_url)
    end

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

    it "denies access to 'index'" do
      get :index
      response.should have_text("You don't have access here.")
    end

    it "denies access to 'show'" do
      get :show, :id => "1"
      response.should have_text("You don't have access here.")
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
      it "assigns all venues as @venues" do
        Venue.stub!(:find).with(:all).and_return([mock_venue])
        get :index
        assigns[:venues].should == [mock_venue]
      end
    end

    describe "GET show" do
      it "assigns the requested venue as @venue" do
        Venue.stub!(:find).with("37").and_return(mock_venue)
        get :show, :id => "37"
        assigns[:venue].should equal(mock_venue)
      end
    end

    describe "GET new" do
      it "assigns a new venue as @venue" do
        Venue.stub!(:new).and_return(mock_venue)
        get :new
        assigns[:venue].should equal(mock_venue)
      end
    end

    describe "GET edit" do
      it "assigns the requested venue as @venue" do
        Venue.stub!(:find).with("37").and_return(mock_venue)
        get :edit, :id => "37"
        assigns[:venue].should equal(mock_venue)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "assigns a newly created venue as @venue" do
          Venue.stub!(:new).with({'these' => 'params'}).and_return(mock_venue(:save => true))
          post :create, :venue => {:these => 'params'}
          assigns[:venue].should equal(mock_venue)
        end

        it "redirects to the created venue" do
          Venue.stub!(:new).and_return(mock_venue(:save => true))
          post :create, :venue => {}
          response.should redirect_to(venues_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved venue as @venue" do
          Venue.stub!(:new).with({'these' => 'params'}).and_return(mock_venue(:save => false))
          post :create, :venue => {:these => 'params'}
          assigns[:venue].should equal(mock_venue)
        end

        it "re-renders the 'new' template" do
          Venue.stub!(:new).and_return(mock_venue(:save => false))
          post :create, :venue => {}
          response.should render_template('new')
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested venue" do
          Venue.should_receive(:find).with("37").and_return(mock_venue)
          mock_venue.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :venue => {:these => 'params'}
        end

        it "assigns the requested venue as @venue" do
          Venue.stub!(:find).and_return(mock_venue(:update_attributes => true))
          put :update, :id => "1"
          assigns[:venue].should equal(mock_venue)
        end

        it "redirects to the venue" do
          Venue.stub!(:find).and_return(mock_venue(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(venues_url)
        end
      end

      describe "with invalid params" do
        it "updates the requested venue" do
          Venue.should_receive(:find).with("37").and_return(mock_venue)
          mock_venue.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :venue => {:these => 'params'}
        end

        it "assigns the venue as @venue" do
          Venue.stub!(:find).and_return(mock_venue(:update_attributes => false))
          put :update, :id => "1"
          assigns[:venue].should equal(mock_venue)
        end

        it "re-renders the 'edit' template" do
          Venue.stub!(:find).and_return(mock_venue(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested venue" do
        Venue.should_receive(:find).with("37").and_return(mock_venue)
        mock_venue.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the venues list" do
        Venue.stub!(:find).and_return(mock_venue(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(venues_url)
      end
    end
  end
end
