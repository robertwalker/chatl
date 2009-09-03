class Attendee < ActiveRecord::Base
  RSVP_STATES = %w{ Yes No Maybe }

  belongs_to :meeting
  belongs_to :user

  validates_presence_of :meeting_id, :user_id
  validates_inclusion_of :rsvp, :in => RSVP_STATES,
                                :message => "must be Yes, No or Maybe"
end
