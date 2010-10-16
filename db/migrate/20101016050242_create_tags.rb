class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :product_id
      t.string  :tag
    end
  end

  def self.down
    drop_table :tags
  end
end
