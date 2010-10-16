class TagsHaveAnIndex < ActiveRecord::Migration
  def self.up
    add_column :tags, :index, :integer, :default => 0
  end

  def self.down
    remove_column :tags, :index
  end
end
