class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.remember_me = true
    @success = false
    if @user_session.save
      @success = true
      redirect_to root_url
    else
      @user_session = UserSession.new(params[:user_session])
      flash[:error] = "Oops, that password wasn't right. Try again; you'll get it this time."
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to root_url
  end
end