class CreateKeywordIndexesForAllProducts < ActiveRecord::Migration
  def self.up
    Product.all.each do |product|
      Keyword.update_keywords_for(product)
    end
  end

  def self.down
    Product.all.each {|product| product.keywords.each(&:destroy)}
  end
end
