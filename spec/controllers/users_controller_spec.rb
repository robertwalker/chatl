require File.dirname(__FILE__) + '/../spec_helper'
  
describe UsersController do
  fixtures :users

  describe 'not logged in' do
    it 'denies access to #index' do
      get :index
      response.should redirect_to(new_session_url)
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
