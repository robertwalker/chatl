class AddPresentedByToPresentations < ActiveRecord::Migration
  def self.up
    add_column :presentations, :presented_by, :string
  end

  def self.down
    remove_column :presentations, :presented_by
  end
end
