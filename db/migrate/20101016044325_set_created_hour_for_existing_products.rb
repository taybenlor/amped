class SetCreatedHourForExistingProducts < ActiveRecord::Migration
  def self.up
    Product.all.each do |product|
      product.created_hour = product.created_at.to_i / (60 * 60)
      product.save
    end
  end

  def self.down
  end
end
