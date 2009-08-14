class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.integer :seating_capacity
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
