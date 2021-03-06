class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'

    @body[:url]  = "http://cocoaheadsatlanta.org/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://cocoaheadsatlanta.org/login"
  end

  def chatter_list(user)
    @recipients  = "chatter-join@lists.cocoaheadsatlanta.org"
    @from        = "#{user.email}"
    @subject     = ""
    @sent_on     = Time.now
  end

  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "noreply.cocoaheadsatlanta.org"
    @subject     = "[CocoaHeads: Atlanta] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
