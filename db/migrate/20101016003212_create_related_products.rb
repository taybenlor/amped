class CreateRelatedProducts < ActiveRecord::Migration
  def self.up
    create_table :related_products do |t|
      t.integer :product_one_id
      t.integer :product_two_id
      t.decimal :similarity
    end
  end

  def self.down
    drop_table :related_products
  end
end
