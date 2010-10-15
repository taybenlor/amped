class Comment < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  
  validates_presence_of :product_id
  validates_presence_of :user_id
  validates_presence_of :comment
  
end
