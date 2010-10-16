class Product < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :purchases
  
  validates_presence_of :user_id
  validates_presence_of :description
  validates_presence_of :name
  
  has_attached_file :thumbnail, :styles => {:thumb => "128x128"}
  has_attached_file :preview
  has_attached_file :file
  
  def update_like_count
    self.like_cache = self.likes.count
    self.save
  end
  
  def update_purchase_count
    self.purchase_cache = self.purchases.count
    self.save
  end
end
