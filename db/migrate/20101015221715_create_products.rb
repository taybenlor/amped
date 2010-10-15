class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :thumbnail_file_name
      t.string :thumbnail_content_type
      t.integer :thumbnail_file_size
      t.datetime :thumbnail_updated_at
      t.string :file_file_name
      t.string :file_content_type
      t.integer :thumbnail_file_size
      t.datetime :file_updated_at
      t.string :preview_file_name
      t.string :preview_content_type
      t.integer :preview_file_size
      t.datetime :preview_updated_at
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
