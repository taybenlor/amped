class RelatedProduct < ActiveRecord::Base
  belongs_to :product_one, class_name: 'Product'
  belongs_to :product_two, class_name: 'Product'
  after_create :recalculate_similarity

  # FIXME: similarities should also be calculated on purchases, not just likes
  
  # since the only user -> product pairing we have
  # is likes (which are binary) the similarity
  # between products is defined as the jaccard
  # coefficient between the two user_id vectors
  # produced by the likes of each product
  def recalculate_similarity
    query_one = Like.select(:user_id).where(product_id: product_one_id).order('user_id asc').to_sql
    query_two = Like.select(:user_id).where(product_id: product_two_id).order('user_id asc').to_sql
    user_ids_one = ActiveRecord::Base.connection.execute(query_one).column_values(0)
    user_ids_two = ActiveRecord::Base.connection.execute(query_two).column_values(0)
    intersection = (user_ids_one & user_ids_two).size
    union = (user_ids_one | user_ids_two).size
    
    if intersection == 0 || union == 0
      self.similarity = 0
    else
      self.similarity = intersection.to_f / union.to_f
    end
    self.save
  end
  
  # similarity between A & B is commutative so
  # define the store as product_one being the
  # lower of the two ids
  def self.record_for(product_one, product_two)
    return nil if product_one == product_two
    ids = [product_one.id, product_two.id].sort
    RelatedProduct.find_or_create_by_product_one_id_and_product_two_id(ids[0], ids[1])
  end
end
