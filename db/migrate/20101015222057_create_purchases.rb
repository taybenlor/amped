class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.integer :user_id
      t.integer :product_id
      t.decimal :amount
      t.boolean :confirmed

      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
