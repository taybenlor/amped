class Like < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  
  # likes affect the similarity of products to one another
  after_create  :update_related_products
  after_destroy :update_related_products
  def update_related_products
    self.product.update_related_product_records
  end
  
  # for speed cache the number of likes of a product
  after_create  :update_like_count
  after_destroy :update_like_count
  def update_like_count
    self.product.update_like_count
  end
end
