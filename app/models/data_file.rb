class DataFile < ActiveRecord::Base
  validates_presence_of :comment, :name, :content_type
end
