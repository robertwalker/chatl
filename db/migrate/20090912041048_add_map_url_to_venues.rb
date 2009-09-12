class AddMapUrlToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :map_url, :text
  end

  def self.down
    remove_column :venues, :map_url
  end
end
