class CommentsController < ApplicationController  
  def create
    @comment = Comment.new(params[:comment])
    @comment.product_id = params[:product_id]
    @comment.user = current_user
    @comment.save
    redirect_to :back
  end
end
