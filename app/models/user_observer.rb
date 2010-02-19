class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user) unless user.identity_url.ends_with?("_pending")
  end

  def after_save(user)
    if user.recently_activated?
      UserMailer.deliver_activation(user)
      UserMailer.deliver_chatter_list(user) if user.subscribe_to_chatter?
    end
  end
end
