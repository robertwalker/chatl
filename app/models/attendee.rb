class Attendee < ActiveRecord::Base
  RSVP_STATES = %w{ Yes No Maybe }

  belongs_to :user
  belongs_to :meeting

  validates_presence_of :user_id, :meeting_id
end
