class CreateSocialNetworks < ActiveRecord::Migration
  def self.up
    create_table :social_networks do |t|
      t.integer :user_id, :null => false
      t.string :network, :null => false
      t.string :username, :null => false
      t.boolean :make_public, :default => false, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :social_networks
  end
end
