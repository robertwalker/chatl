class AddTitleToMeetings < ActiveRecord::Migration
  def self.up
    add_column :meetings, :title, :string
  end

  def self.down
    remove_column :meetings, :title
  end
end
