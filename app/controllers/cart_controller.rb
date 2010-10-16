class CartController < ApplicationController
  
  # Includes active merchant gem
  include ActiveMerchant::Billing

  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  def index
    @cart = session[:cart]
  end

  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  def new
    items = ['1', '2', '3']
    session[:cart] = items
    redirect_to :action => 'index'
  end

  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  def destroy
    
    # Fetch items
    items = session[:cart]
    
    # What value are we deleting?
    @id = params[:id]
    
    # Delete!
    items.delete(@id)
    
    # Redirect to index
    redirect_to :action => 'index'
  end
  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  def clear
    session[:cart] = ''
    redirect_to :action => 'index'    
  end
  
  # Paypal CHECKOUT Method
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum
  def checkout
    
    # TODO: Need to fetch a total for all the items in the cart
    items = session[:cart]
    
    # Total
    @total = 0
    
    # Loop through each item in cart and add to totel
    items.each do |item|
      @product = Product.find(item)
      @total += @product.amount
    end
    
    # Make sure total greater than 0..
    if @total > 0
      
      setup_response = gateway.setup_purchase(@total,
        :ip                => request.remote_ip,
        :return_url        => url_for(:action => 'confirm', :only_path => false),
        :cancel_return_url => url_for(:action => 'index', :only_path => false)
      )
      redirect_to gateway.redirect_url_for(setup_response.token)
      
    else
      flash[:error] = "Total is 0 - wtf?"
    end
  end

  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum    
  def confirm
    redirect_to :action => 'index' unless params[:token]

    details_response = gateway.details_for(params[:token])

    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end

    @address = details_response.address
  end
  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  def complete
    purchase = gateway.purchase(5000,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )

    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    end
  end
      
  private
  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum
    def gateway
      @gateway ||= PaypalExpressGateway.new(
        :login => 'nybles_1287187717_biz_api1.visualconnect.net',
        :password => 'H5SU5XRYH27QZXYB',
        :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31Aru-BRPlXkQrXRcew2eXUkSbyYU1'
      )
    end
end