class CartController < ApplicationController
  # Includes active merchant gem
  include ActiveMerchant::Billing
  
  # Paypal CHECKOUT Method
  def checkout
    setup_response = gateway.setup_purchase(5000,
      :ip                => request.remote_ip,
      :return_url        => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => 'index', :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end
    
  private
    def gateway
      @gateway ||= PaypalExpressGateway.new(
        :login => 'API Login',
        :password => 'API Password',
        :signature => 'API Signature'
      )
    end
end