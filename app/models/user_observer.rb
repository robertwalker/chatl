class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user) unless user.identity_url.ends_with?("_pending")
  end

  def after_save(user)
    if user.recently_activated?
      UserMailer.deliver_activation(user)
    end

    unless user.identity_url.ends_with?("_pending")
      UserMailer.deliver_signup_notification(user)
    end
  end
end
