class AddUniqueIndexToUserIdentityUrl < ActiveRecord::Migration
  def self.up
    add_index :users, :identity_url, :unique => true
  end

  def self.down
    remove_index :users, :identity_url
  end
end
