require File.dirname(__FILE__) + '/../spec_helper'
  
describe UsersController do
  fixtures :users

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe 'not logged in' do
    it 'denies access to #index' do
      get :index
      response.should redirect_to(new_session_url)
    end

    it 'denies access to #edit' do
      get :edit, :id => "37"
      response.should redirect_to(new_session_url)
    end
  end

  describe "authenticated" do
    before(:each) do
      @user = Factory(:user)
      login_as(@user)
    end

    describe "GET edit" do
      it "assigns the requested user as @user" do
        get :edit, :id => @user.id.to_s
        assigns[:user].should == @user
      end

      it "denies access to other users other than 'current_user'" do
        steve = Factory(:steve)
        get :edit, :id => steve.id.to_s
        flash[:error].should == "Sorry, you may only edit your own profile."
        response.should redirect_to(root_url)
      end
    end

    describe "PUT update" do
      before(:each) do
        User.stub!(:find).with(:first,
                               { :conditions => { :id => @user.id}}).
                               and_return(@user)
      end

      describe "with valid params" do
        it "assigns the requested user as @user" do
          User.stub!(:find).with("37").and_return(mock_user(:update_attributes => true))
          put :update, :id => "37"
          assigns[:user].should equal(mock_user)
        end

        it "updates the requested user" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :user => {'these' => 'params'}
        end

        it "redirects to the users index page" do
          User.stub!(:find).with("37").and_return(mock_user(:update_attributes => true))
          put :update, :id => "37"
          response.should redirect_to(users_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested user as @user" do
          User.stub!(:find).with("37").and_return(mock_user(:update_attributes => false))
          put :update, :id => "37"
          assigns[:user].should equal(mock_user)
        end

        it "updates the requested user" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :user => {:these => 'params'}
        end

        it "re-renders the 'edit' template" do
          User.stub!(:find).with("37").and_return(mock_user(:update_attributes => false))
          put :update, :id => "37"
          response.should render_template('edit')
        end
      end
    end
  end

  describe 'sign up' do
    it 'allows signup' do
      lambda do
        create_user
        response.should be_redirect
      end.should change(User, :count).by(1)
    end

    it 'signs up user in pending state' do
      create_user
      assigns(:user).reload
      assigns(:user).should be_pending
    end

    it 'signs up user with activation code' do
      create_user
      assigns(:user).reload
      assigns(:user).activation_code.should_not be_nil
    end

    it 'requires identity_url on signup' do
      lambda do
        create_user(:identity_url => nil)
        assigns[:user].errors.on(:identity_url).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end

    it 'requires email on signup' do
      lambda do
        create_user(:email => nil)
        assigns[:user].errors.on(:email).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end
  end

  describe 'activation' do
    it 'activates user' do
      User.authenticate(nil, 'aaron', 'monkey').should be_nil
      get :activate, :activation_code => users(:aaron).activation_code
      response.should redirect_to('/login')
      flash[:notice].should_not be_nil
      flash[:error ].should     be_nil
      User.authenticate(nil, 'aaron', 'monkey').should == users(:aaron)
    end

    it 'does not activate user without key' do
      get :activate
      flash[:notice].should     be_nil
      flash[:error ].should_not be_nil
    end

    it 'does not activate user with blank key' do
      get :activate, :activation_code => ''
      flash[:notice].should     be_nil
      flash[:error ].should_not be_nil
    end

    it 'does not activate user with bogus key' do
      get :activate, :activation_code => 'i_haxxor_joo'
      flash[:notice].should     be_nil
      flash[:error ].should_not be_nil
    end
  end

  def create_user(options = {})
    post :create, :user => {
      :identity_url => "http://quire.example.com/",
      :email => 'quire@example.com'}.merge(options)
  end
end
