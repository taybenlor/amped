class CreateKeywordIndexesForAllProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :keyword_magnitude, :float
    Product.all.each do |product|
      Keyword.update_keywords_for(product)
    end
  end

  def self.down
    Product.all.each {|product| product.keywords.each(&:destroy)}
    remove_column :products, :keyword_magnitude
  end
end
