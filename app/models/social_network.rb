class SocialNetwork < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :network, :username
end
