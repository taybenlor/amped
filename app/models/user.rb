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
  
  validates_presence_of :name
  
  def password_reset!  
    reset_perishable_token!  
    NotificationMailer.password_reset(self).deliver
  end
end
