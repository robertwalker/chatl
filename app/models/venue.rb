class Venue < ActiveRecord::Base
  has_many :meetings

  validates_presence_of :name, :street_address, :city, :state, :zip
  validates_length_of :state, :is => 2
  validates_numericality_of :seating_capacity, :only_integer => true, :allow_nil => true
  before_validation { |venue| venue.state.upcase! if venue.state }
end
