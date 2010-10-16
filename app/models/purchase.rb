class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  
  validates_presence_of :user_id
  validates_presence_of :product_id
  validates_presence_of :amount
  
  after_create :update_like_count
  
  def update_like_count
    self.product.update_purchase_count
  end
end
