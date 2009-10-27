class CreateDataFiles < ActiveRecord::Migration
  def self.up
    create_table :data_files do |t|
      t.string :comment
      t.string :name
      t.string :content_type, :default => 'application/octetstream'

      t.timestamps
    end
  end

  def self.down
    drop_table :data_files
  end
end
