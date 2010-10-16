class Keyword < ActiveRecord::Base
  belongs_to :product
  
  def self.extract_keywords(text)
    # preprocessing
    text.gsub!(/(\w+)'(\w+)/, '\1\2')
    words = text.scan(/\w+/).collect(&:downcase)
    
    # counts
    word_counts = Hash.new(0)
    max_count = 0
    words.each do |word|
      count = (word_counts[word] += 1)
      puts "word: #{count}"
      max_count = count if count > max_count
    end
    
    # probabilistic log score weighting
    max_count = 0.1 + Math.log(max_count)
    word_counts.each do |word, count|
      score = 0.5 + ((0.1 + Math.log(count)) / max_count)
      word_counts[word] = score
    end
  end
    
  def self.update_keywords_for(product)
    product.keywords.each(&:destroy)
    score_sum = 0
    keywords  = extract_keywords("#{product.name} #{product.description}")
    keywords.each do |word, score|
      Keyword.create(product_id: product.id, keyword: word, score: score)
      score_sum += score
    end
    
    # apparently update_attribute does actually run callbacks.....
    product.reload
    product.update_attribute(:keyword_magnitude, score_sum / keywords.size)
  end
  
  def self.search_for(query, offset=0, limit=100)
    scored_keywords = extract_keywords(query)
    query_magnitude = scored_keywords.values.sum / scored_keywords.size
    keywords = scored_keywords.keys
    
    # find the ids of all products containing at least
    # one of the search keywords
    query = Keyword.select('distinct product_id').where(keyword: keywords).to_sql
    product_ids = ActiveRecord::Base.connection.execute(query).column_values(0)
    
    # rank the products using cosine similarity
    products = Product.find(product_ids).sort_by {|product| -product.cosine_similarity_to(scored_keywords, query_magnitude)}
    products[offset..(offset + limit)]
  end
end
