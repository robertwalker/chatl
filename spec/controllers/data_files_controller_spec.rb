require 'spec_helper'

describe DataFilesController do

  def mock_data_file(stubs={})
    @mock_data_file ||= mock_model(DataFile, stubs)
  end

  describe "GET index" do
    it "assigns all data_files as @data_files" do
      DataFile.stub!(:find).with(:all).and_return([mock_data_file])
      get :index
      assigns[:data_files].should == [mock_data_file]
    end
  end

  describe "GET download" do
    it "assigns the requested data_file as @data_file" do
      DataFile.stub!(:find).with("37").and_return(mock_data_file)
      mock_data_file.should_receive(:absolute_path).and_return("/system/downloads/text.txt")
      mock_file = mock(File)
      controller.should_receive(:send_file).and_return(mock_file)
      get :download, :id => "37"
      assigns[:data_file].should equal(mock_data_file)
      response.should be_success
    end

    it "should present error and redirect to 'index' when file is not found" do
      DataFile.stub!(:find).with("37").and_return(mock_data_file)
      mock_data_file.should_receive(:absolute_path).and_return("/system/downloads/text.txt")
      controller.should_receive(:send_file).and_raise(ActionController::MissingFile)
      get :download, :id => "37"
      response.should render_template("#{RAILS_ROOT}/public/404.html")
      response.response_code.should == 404
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
      put :update, :id => "1", :venue => {:these => 'params'}
      response.should redirect_to(new_session_url)
    end

    it "denies access to 'destroy'" do
      delete :destroy, :id => "1"
      response.should redirect_to(new_session_url)
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

    describe "GET new" do
      it "assigns a new data_file as @data_file" do
        DataFile.stub!(:new).and_return(mock_data_file)
        get :new
        assigns[:data_file].should equal(mock_data_file)
      end
    end

    describe "GET edit" do
      it "assigns the requested data_file as @data_file" do
        DataFile.stub!(:find).with("37").and_return(mock_data_file)
        get :edit, :id => "37"
        assigns[:data_file].should equal(mock_data_file)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "assigns a newly created data_file as @data_file" do
          DataFile.stub!(:new).with({'these' => 'params'}).and_return(mock_data_file(:save => true))
          post :create, :data_file => {:these => 'params'}
          assigns[:data_file].should equal(mock_data_file)
        end

        it "redirects to the data_files index" do
          DataFile.stub!(:new).and_return(mock_data_file(:save => true))
          post :create, :data_file => {}
          response.should redirect_to(data_files_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved data_file as @data_file" do
          DataFile.stub!(:new).with({'these' => 'params'}).and_return(mock_data_file(:save => false))
          post :create, :data_file => {:these => 'params'}
          assigns[:data_file].should equal(mock_data_file)
        end

        it "re-renders the 'new' template" do
          DataFile.stub!(:new).and_return(mock_data_file(:save => false))
          post :create, :data_file => {}
          response.should render_template('new')
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested data_file" do
          DataFile.should_receive(:find).with("37").and_return(mock_data_file)
          mock_data_file.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :data_file => {:these => 'params'}
        end

        it "assigns the requested data_file as @data_file" do
          DataFile.stub!(:find).and_return(mock_data_file(:update_attributes => true))
          put :update, :id => "1"
          assigns[:data_file].should equal(mock_data_file)
        end

        it "redirects to the data_file" do
          DataFile.stub!(:find).and_return(mock_data_file(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(data_files_url)
        end
      end

      describe "with invalid params" do
        it "updates the requested data_file" do
          DataFile.should_receive(:find).with("37").and_return(mock_data_file)
          mock_data_file.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :data_file => {:these => 'params'}
        end

        it "assigns the data_file as @data_file" do
          DataFile.stub!(:find).and_return(mock_data_file(:update_attributes => false))
          put :update, :id => "1"
          assigns[:data_file].should equal(mock_data_file)
        end

        it "re-renders the 'edit' template" do
          DataFile.stub!(:find).and_return(mock_data_file(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested data_file" do
        DataFile.should_receive(:find).with("37").and_return(mock_data_file)
        mock_data_file.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the data_files list" do
        DataFile.stub!(:find).and_return(mock_data_file(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(data_files_url)
      end
    end
  end
end
