class ProductsDontNeedTagsText < ActiveRecord::Migration
  def self.up
    remove_column :products, :tags_text
  end

  def self.down
    add_column :products, :tags_text, :string
  end
end
