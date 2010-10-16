class Product < ActiveRecord::Base
  belongs_to  :user
  has_many    :likes
  has_many    :purchases
  has_many    :keywords
  has_many    :product_previews
  
  validates_presence_of :user_id
  validates_presence_of :description
  validates_presence_of :name
  
  has_attached_file :thumbnail, :styles => {:thumb => "128x128"}
  has_attached_file :preview
  has_attached_file :file
  
  # caches
  def update_like_count
    update_attribute(:like_cache, self.likes.count)
  end
  
  def update_purchase_count
    update_attribute(:purchase_cache, self.purchases.count)
  end
  
  # searching
  after_save :update_keywords
  def update_keywords
    Keyword.update_keywords_for(self)
  end
  
  # related products
  after_create :add_related_product_records
  def add_related_product_records
    Product.all.each {|product| RelatedProduct.record_for(self, product)}
  end
  
  def update_related_product_records
    Product.all.each {|product| RelatedProduct.record_for(self, product).recalculate_similarity}
  end
  
  def related_products(limit=100)
    query = RelatedProduct.where("(product_one_id = ? or product_two_id = ?) and similarity != 0", self.id, self.id)
    sql   = query.select('product_one_id, product_two_id').order('similarity desc').limit(limit).to_sql
    ids   = ActiveRecord::Base.connection.execute(sql).collect do |row|
      row["product_one_id"].to_i == self.id ? row["product_two_id"].to_i : row["product_one_id"].to_i
    end
    Product.find(ids)
  end
end
