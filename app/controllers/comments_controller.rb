class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    comment = current_user.comments.new(comment_params)
    comment.post = @post
    if comment.save
      redirect_back fallback_location: post_path(@post),notice: "コメントしました"
    else
      redirect_back fallback_location: post_path(@post), alert: "コメントを入力してください"
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy
    redirect_back fallback_location: post_path(@post), notice: "コメントを削除しました"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
