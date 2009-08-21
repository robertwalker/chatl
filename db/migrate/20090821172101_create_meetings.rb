class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.integer :venue_id
      t.datetime :scheduled_at
      t.text :details

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
