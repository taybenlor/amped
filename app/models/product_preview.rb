class ProductPreview < ActiveRecord::Base
  has_many :products
  has_attached_file :preview, :styles => { :medium => "500x300>", :thumb => "180x125>" }
end