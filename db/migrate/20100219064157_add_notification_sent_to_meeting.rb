class AddNotificationSentToMeeting < ActiveRecord::Migration
  def self.up
    add_column :meetings, :notification_sent, :string
  end

  def self.down
    remove_column :meetings, :notification_sent
  end
end
