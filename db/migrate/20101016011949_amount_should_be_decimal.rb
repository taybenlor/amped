class AmountShouldBeDecimal < ActiveRecord::Migration
  def self.up
    change_column :products, :amount, :decimal
  end

  def self.down
    change_column :products, :amount, :float
  end
end
