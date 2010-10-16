class ProductsStoreTheirMagnitude < ActiveRecord::Migration
  def self.up
    add_column :products, :keyword_magnitude, :float
  end

  def self.down
    remove_column :products, :keyword_magnitude
  end
end
