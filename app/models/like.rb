class Like < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  
  after_create  :update_related_products
  after_destroy :update_related_products
  def update_related_products
    self.product.update_related_product_records
  end
end
