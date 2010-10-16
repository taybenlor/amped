class Product < ActiveRecord::Base
  belongs_to  :user
  has_many    :likes
  has_many    :purchases
  has_many    :keywords
  has_many    :product_previews
  has_many    :tags, :order => 'index asc'
  
  validates_presence_of :user_id
  validates_presence_of :description
  validates_presence_of :name
  validates_numericality_of :amount, :on => :create, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 200
  
  
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
  
  
  # trending
  before_create :set_created_hour
  def set_created_hour
    self.created_hour = Time.zone.now.to_i / (60 * 60)
  end
  
  # FIXME: this should take in to account purchases as well as likes
  def self.trending(limit=100)
    current_hours = Time.zone.now.to_i / (60 * 60)
    query = Product.select("*, ((like_cache) / power(#{current_hours} - created_hour, 1.8)) as score")
    query.order('score desc').limit(limit).all
  end
  
  # tags
  def set_tags(text)
    self.tags.each(&:destroy)
    text.split(',').collect(&:downcase).collect(&:strip).each do |tag|
      Tag.create(product_id: self.id, tag: tag)
    end
  end
  
  
  # searching
  after_save :update_keywords, :update_tags
  def update_keywords
    return unless name_changed? || description_changed?
    return if keyword_magnitude_changed?
    Keyword.update_keywords_for(self)
  end
  
  def update_tags
    self.set_tags(self.tags_text) if self.tags_text
  end
  
  def cosine_similarity_to(vector, magnitude)
    dp = self.keywords.where(keyword: vector.keys).inject(0) do |sum, keyword|
      sum + (keyword.score * vector[keyword.keyword])
    end
    dp / (magnitude * self.keyword_magnitude)
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
