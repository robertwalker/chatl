# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    if using_open_id?
      open_id_authentication
    else
      user = User.authenticate(params[:login], params[:password])
      if user
        # Protects against session fixation attacks, causes request forgery
        # protection if user resubmits an earlier form using back
        # button. Uncomment if you understand the tradeoffs.
        # reset_session
        self.current_user = user
        new_cookie_flag = (params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
        redirect_back_or_default('/')
        flash[:notice] = "Logged in successfully"
      else
        note_failed_signin
        @login       = params[:login]
        @remember_me = params[:remember_me]
        render :action => 'new'
      end
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  protected
  def open_id_authentication
    authenticate_with_open_id do |result, identity_url|
      if result.successful? && @current_user = User.find_by_identity_url(identity_url)
        successful_login
      else
        failed_login result.message
      end
    end
  end

  private
  def successful_login
    session[:user_id] = @current_user.id
    redirect_to root_url
  end

  def failed_login(message)
    flash[:error] = message || "Please sign up before attempting to log in!"
    if message
      redirect_to new_session_url
    else
      redirect_to signup_url
    end
  end

  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
