class ProductAmountShouldBeDecimal < ActiveRecord::Migration
  def self.up
    remove_column :products, :amount
    add_column :products, :amount, :decimal
  end

  def self.down
    remove_column :products, :amount
    add_column :products, :amount, :float
  end
end
