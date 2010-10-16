module ProductsHelper
  def trending_products_by_tag
    products = Product.trending(100)
    clusters = Hash.new([])
    products.each do |product|
      clusters[product.tags.first.tag] += [product]
    end    
    clusters
  end
  
  def trending_power_graph(product)
    hour = Time.zone.now.to_i / (60 * 60)
    series = []
    #product.created_hour.upto(hour).each do |hour|
    #  likes = Like.where("product_id = ? and created_at <= ?", product.id, Time.at(hour * 60 * 60)).count
    #  power = likes / (((hour - product.created_hour) + 2) ** 1.8)
    #  series << power
    #end
    likes = 0
    50.times do |i|
      if rand > 0.5
        likes += rand(5)
      end
      series << likes / ((i + 2) ** 1.8)
    end
    "http://chart.apis.google.com/chart?cht=lc&chs=300x225&chds=#{series.min},#{series.max}&chd=t:#{series.join(',')}"
  end
end
