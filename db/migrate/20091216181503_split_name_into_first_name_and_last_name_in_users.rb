class SplitNameIntoFirstNameAndLastNameInUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.remove :name
      t.string :first_name, :limit => 100, :default => ""
      t.string :last_name, :limit => 100, :default => ""
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :last_name
      t.remove :first_name
      t.string :name, :limit => 100, :default => ""
    end
  end
end
