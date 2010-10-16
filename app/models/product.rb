class Product < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :purchases
  has_many :related_products, :order => 'similarity desc'
  
  validates_presence_of :user_id
  validates_presence_of :description
  validates_presence_of :name
  
  has_attached_file :thumbnail, :styles => {:thumb => "128x128"}
  has_attached_file :preview
  has_attached_file :file
end
