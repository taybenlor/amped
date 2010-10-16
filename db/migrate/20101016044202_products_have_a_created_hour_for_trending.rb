class ProductsHaveACreatedHourForTrending < ActiveRecord::Migration
  def self.up
    add_column :products, :created_hour, :integer
  end

  def self.down
    remove_column :products, :created_hour
  end
end
