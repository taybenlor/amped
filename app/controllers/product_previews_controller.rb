class ProductPreviewsController < ApplicationController
  
  def create
    @preview = ProductPreview.new(params[:product_preview])
    @preview.product_id = params[:product_id]
    @preview.save    
    redirect_to '/products/' + params[:product_id].to_s
  end
  
end