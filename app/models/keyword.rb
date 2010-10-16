class Keyword < ActiveRecord::Base
  belongs_to :product
  
  # TODO: this should be a little more involved than 2 regexs.... need penn treebank tokeniser
  def self.extract_keywords_from_text(text)
    text.gsub!(/(\w+)'(\w+)/, '\1\2')
    text.scan(/\w+/).collect(&:downcase)
  end
  
  def self.update_keywords_for(product)
    product.keywords.each(&:destroy)
    words = extract_keywords_from_text("#{product.name} #{product.description}")
    
    # counts
    word_counts = Hash.new(0)
    max_count = 0
    words.each do |word|
      count = word_counts[word] += 1
      max_count = count if count > max_count
    end
    
    # probabilistic log score weighting
    max_count = 0.1 + Math.log(max_count)
    word_counts.each do |word, count|
      score = 0.5 + ((0.1 + Math.log(count)) / max_count)
      Keyword.create(product_id: product.id, keyword: word, score: score)
    end
  end
end
