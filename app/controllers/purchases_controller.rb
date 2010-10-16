class PurchasesController < ApplicationController
  
  # Includes active merchant gem
  include ActiveMerchant::Billing

  def index
    @purchases = current_user.purchases
  end
  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum
  def new
    
    # Find product
    @product = Product.where(:id => params[:product_id]).first
    
    # TOTAL must be in cents 
    @total = (@product.amount * 100).to_i
    
    # Store product that we are purchasing in session
    array = ["#{@product.id}"]
    session[:purchase_ids] = array
    
    if !@product.blank?
      
      # Setup the Paypal purchase and redirect for confirmation
      setup_response = gateway.setup_purchase(@total,
        :ip                => request.remote_ip,
        :return_url        => url_for(:controller => 'cart', :action => 'confirm', :only_path => false),
        :cancel_return_url => url_for(:controller => 'cart', :action => 'index', :only_path => false)
      )      
      redirect_to gateway.redirect_url_for(setup_response.token)
      
    else
      render 'error'
    end
  end  
end