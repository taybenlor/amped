class CreateInitialRelatedProductRecords < ActiveRecord::Migration
  def self.up
    Product.all.each do |product|
      product.add_related_product_records
    end
  end

  def self.down
    RelatedProduct.all.each(&:destroy)
  end
end
