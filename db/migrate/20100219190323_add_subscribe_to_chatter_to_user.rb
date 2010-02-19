class AddSubscribeToChatterToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribe_to_chatter, :boolean, :default => false
  end

  def self.down
    remove_column :users, :subscribe_to_chatter
  end
end
