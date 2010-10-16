class AddTagsToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :tags_text, :string, :default => ""
  end

  def self.down
    remove_column :products, :tags_text
  end
end
