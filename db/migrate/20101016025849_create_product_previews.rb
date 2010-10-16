class CreateProductPreviews < ActiveRecord::Migration
  def self.up
    create_table :product_previews do |t|
      t.integer   :product_id
      t.string    :product_file_name
      t.string    :product_content_type
      t.integer   :product_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :product_previews
  end
end