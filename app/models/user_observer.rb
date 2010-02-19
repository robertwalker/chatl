class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user) unless user.identity_url.ends_with?("_pending")
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_activated?
  end
end
