class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user

  def edit
    @auth = params[:auth]
  end  
  
  def new 
  end

  def update
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation] 
    if @user.save 
      flash[:notice] = "Your password has been changed."
      @user.reset_perishable_token!
      redirect_to :root  
    else  
      puts 'nope'
      render :action => :edit  
    end  
  end 
  
  def create  
    @user = User.where(:email => params[:email]).first
    if @user  
      @user.password_reset!
      flash[:notice] = "It&rsquo;s OK, these things happen. To reset your password, follow the instructions in the email we just sent you."  
      redirect_to root_url
    else  
      flash[:notice] = "You didn&rsquo;t sign up to Halftone with this email address. Try another."  
      redirect_to new_user_session_url 
    end  
  end

  private  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:auth])  
    unless @user  
      flash[:notice] = "We&rsquo;re sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "reset password process."  
      redirect_to root_url
    end
  end 
end
