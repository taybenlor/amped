class LikesController < ApplicationController
  def create
    @like = Like.new
    @like.user = current_user
    @like
    @like = current_user.likes.where(id: params[:like]).first
  end

  def destroy
    @like = current_user.likes.where(id: params[:like]).first
    @like && @like.destroy
  end
end
