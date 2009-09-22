class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.string :title
      t.date :presented_on
      t.text :narrative

      t.timestamps
    end
  end

  def self.down
    drop_table :presentations
  end
end
