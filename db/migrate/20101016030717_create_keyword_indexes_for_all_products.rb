class CreateKeywordIndexesForAllProducts < ActiveRecord::Migration
  def self.up
    Product.all.each {|product| product.update_keywords}
  end

  def self.down
    Product.all.each {|product| product.keywords.each(&:destroy)}
  end
end
