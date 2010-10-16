class FixpreviewCols < ActiveRecord::Migration
  def self.up
    rename_column :product_previews, :product_file_name, :preview_file_name
    rename_column :product_previews, :product_content_type, :preview_content_type
    rename_column :product_previews, :product_file_size, :preview_file_size
  end

  def self.down
  end
end