class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  
  after_create :update_like_count
  
  def update_like_count
    self.product.update_like_count
  end
end
