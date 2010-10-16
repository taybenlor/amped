class PurchasesController < ApplicationController
  
  # Includes active merchant gem
  include ActiveMerchant::Billing

  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum
  def new
    @product = Product.where(:id => params[:product_id]).first
    
    if @product.blank?
      setup_response = gateway.setup_purchase(@product.amount,
        :ip                => request.remote_ip,
        :return_url        => url_for(:action => 'confirm', :only_path => false),
        :cancel_return_url => url_for(:action => 'index', :only_path => false)
      )
      redirect_to gateway.redirect_url_for(setup_response.token)
    end
  end  
end