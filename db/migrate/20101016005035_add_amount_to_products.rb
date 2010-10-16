class AddAmountToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :amount, :float
  end

  def self.down
    remove_column :products, :amount
  end
end
