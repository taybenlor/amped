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
  def create        
    @id = params[:id]
    items = session[:cart]
    
    if items.blank?
      items = ["#{@id}"]
    else
      items << "#{@id}"
    end
  
    session[:cart] = items
  end
  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  def new
    items = ['1', '2']
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
    
    array = []
    
    # Loop through each item in cart and add to totel
    items.each do |item|
      @product = Product.find(item)
      @total += @product.amount
      
      array << "#{@product.id}"
    end
    
    # Store product that we are purchasing in session
    session[:purchase_ids] = array
    
    # Make sure total greater than 0..
    if @total > 0
      
      # TOTAL must be in cents 
      @total = (@total * 100).to_i
    
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

    # Paypal objects
    @address = details_response.address     
    @order_total = details_response.params['order_total']
    
    # Fetch items
    items = session[:purchase_ids]
    puts '-----------------------'
    puts items
    puts '-----------------------'    
  end
  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  # Lorem Ipsum, Lorem Ipsum, Lorem Ipsum  
  def complete    
    
    # TOTAL must be in cents 
    @total = params[:order_total]
    @total_in_cents = (@total * 100).to_i
    
    # Confirm purchase
    purchase = gateway.purchase(@total_in_cents,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )

    # FAIL?
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    else 
      
      # Fetch items
      items = session[:purchase_ids]
      
      puts '-----------------------'
      puts 'Array size' + items.size.to_s
      puts '-----------------------'
            
      # Loop through each
      items.each do |i|      
        
        puts 'CREATE PRODUCT'
        
        @product = Product.find(i)
        
        # Create purchase
        @purchase = Purchase.new
        @purchase.user = current_user
        @purchase.product = @product
        @purchase.confirmed = true
        @purchase.amount = @total
        @purchase.save
        
        puts '--------- LOL'
        puts @purchase.errors
      end
           
      redirect_to '/purchases'
     
    end
  end    
end