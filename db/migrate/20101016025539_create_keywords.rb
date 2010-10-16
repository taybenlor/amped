class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords do |t|
      t.integer :product_id
      t.string  :keyword
      t.float   :score
    end
  end

  def self.down
    drop_table :keywords
  end
end
