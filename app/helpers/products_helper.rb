module ProductsHelper
  def trending_products_by_tag
    products = Product.trending(100)
    clusters = Hash.new([])
    
    products.each do |product|
      clusters[product.tags.first.tag] += [product]
    end    
    clusters
  end
end
