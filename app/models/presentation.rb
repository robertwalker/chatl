class Presentation < ActiveRecord::Base
  validates_presence_of :title, :presented_on, :narrative
end
