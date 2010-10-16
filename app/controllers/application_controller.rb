class ApplicationController < ActionController::Base

  # Includes active merchant gem
  include ActiveMerchant::Billing
  
  # Blah
  helper :all
  protect_from_forgery
  layout 'application'
  helper_method :current_user_session, :current_user, :logged_in?

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def logged_in?
      !!current_user
    end
  
    def require_user
      unless current_user
        store_location
        flash[:error] = "Sign in to see the next page. It's all secret handshakes and hush-hush. You understand."
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:error] = "Sign in to see the next page. It's all secret handshakes and hush-hush. You understand."
        redirect_to root_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
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

