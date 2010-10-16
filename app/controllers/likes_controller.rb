class LikesController < ApplicationController
  def create
    @like = Like.new
    @like.user = current_user
    @like.product_id = params[:product_id]
    @like.save
  end

  def destroy
    @like = current_user.likes.where(id: params[:id]).first
    @like && @like.destroy
  end
end
