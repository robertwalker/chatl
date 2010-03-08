class UsersController < ApplicationController
  OPEN_ID_PROVIDERS = [
    'https://www.google.com/accounts/o8/id',
    'http://yahoo.com/'
  ]

  require_role "admin", :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required, :only => :index

  # GET /users
  # GET /users.xml
  def index
    if logged_in? && current_user.admin?
      @users = User.not_deleted
    else
      @users = User.active
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /meetings/1
  # GET /meetings/1.xml
  def show
    @user = User.find(params[:id])
    render :partial => "address_card", :locals => { :user => @user }
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    openid_identifier = params[:openid_identifier]
    if require_openid_verification?(openid_identifier)
      open_id_authentication(openid_identifier)
    else
      @user = User.new(params[:user])
      @user.identity_url ||= openid_identifier
      @user.register! if @user && @user.valid?
      success = @user && @user.valid?
      if success && @user.errors.empty?
        redirect_back_or_default('/')
        flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      else
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact the group organizer (link is in the sidebar)."
        render :action => 'new'
      end
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

  protected
  def require_openid_verification?(openid_identifier)
    OPEN_ID_PROVIDERS.include?(openid_identifier) || params[:open_id_complete]
  end

  def open_id_authentication(openid_identifier)
    success = true
    if params[:open_id_complete].blank?
      success = create_user(openid_identifier)
      session[:open_id_user_id] = @user.id
    else
      logger.debug "LOGGER: #{openid_identifier}"
    end

    if success
      authenticate_with_open_id(openid_identifier) do |result, identity_url|
        @user = User.find(session[:open_id_user_id])
        if result.successful? && @user
          successful_signup(identity_url)
        else
          failed_signup result.message
        end
      end
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact the group organizer (link is in the sidebar)."
      render :action => 'new'
    end
  end

  private
  def find_user
    @user = User.find(params[:id])
  end

  def create_user(open_id_user_id)
    @user = User.new(params[:user])
    @user.identity_url ||= open_id_user_id + "_" + @user.email + "_pending"
    @user.register! if @user && @user.valid?
    @user && @user.valid? && @user.errors.empty?
  end

  def successful_signup(identity_url)
    identity_pending = @user.identity_url.ends_with?("_pending")
    logger.debug "LOGGER: ID = #{@user.id}, #{@user.identity_url}"
    if @user.update_attributes(:identity_url => identity_url)
      UserMailer.deliver_signup_notification(@user) if identity_pending
      flash[:notice] = "Thanks for signing up! We're sending you an email with your activation code."
      session.delete(:open_id_user_id)
      redirect_to root_url
    else
      failed_signup("We couldn't set up that account, sorry. If you are attempting to sign up with Google or Yahoo try signing out of your account then try again. If you still have trouble please contact the group organizer (link is in the sidebar).")
    end
  end

  def failed_signup(message)
    @user.destroy
    session.delete(:open_id_user_id)
    flash[:error] = message
    redirect_to new_user_url
  end
end
