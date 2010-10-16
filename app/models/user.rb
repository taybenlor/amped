class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
  end
  # paperclip
  has_attached_file :avatar, :styles => {:thumb => "128x128"}
  
  has_many :products
  has_many :comments
  has_many :likes
  has_many :purchases
  
  has_many :followers, foreign_key: :following_id, class_name: "Follow"
  has_many :following, foreign_key: :follower_id, class_name: "Follow"
  
  validates_presence_of :name
  
  def password_reset!  
    reset_perishable_token!  
    NotificationMailer.password_reset(self).deliver
  end
  
  def best_seller
    self.products.order("purchase_cache DESC").first
  end
  
  def likes?(product)
    self.likes.where(product_id: product.id).exists?
  end
  
  def get_like(product)
    self.likes.where(product_id: product.id).first
  end
end
