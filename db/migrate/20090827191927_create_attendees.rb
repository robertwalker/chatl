class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees, :id => false do |t|
      t.integer :user_id
      t.integer :meeting_id
      t.string :rsvp

      t.timestamps
    end

    add_index :attendees, [:user_id, :meeting_id], 
              :name => "idx_user_meeting", :unique => true
  end

  def self.down
    remove_index :attendees, "idx_user_meeting"
    drop_table :attendees
  end
end
