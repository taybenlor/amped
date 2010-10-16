class ProductsController < ApplicationController
  # Hmm .. so much cleaner
  respond_to :html, :json, :xml
  before_filter :require_user, :only => [:create, :edit, :update, :destroy]

  def index
    @products = Product.all
    respond_with @products
  end

  def show
    @product = Product.find(params[:id])
    respond_with @product
  end

  def new
    @product = Product.new
    respond_with @product
  end

  def edit
    @product = current_user.products.find(params[:id])
    respond_with @product
  end

  def create
    @product = Product.new(params[:product])
    @product.user = current_user
    if @product.save
      @product.set_tags(params[:tags]) if params[:tags]
      flash[:notice] = 'Your product was successfully created.'
      render :action => :edit
    else
      render :action => :new
    end
  end

  def update
    @product = Product.find(params[:id])
    @product.set_tags(params[:tags]) if params[:tags]
    flash[:notice] = 'Product was successfully updated.' if @product.update_attributes(params[:product])
    respond_with @product
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    respond_with @product
  end
  
  def fetch_preview
    @preview = ProductPreview.find(params[:id])
  end
end