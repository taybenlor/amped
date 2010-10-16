class AddCacheToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :like_cache, :integer, :default => 0
    add_column :products, :purchase_cache, :integer, :default => 0
  end

  def self.down
    remove_column :products, :like_cache
    remove_column :products, :purchase_cache
  end
end
