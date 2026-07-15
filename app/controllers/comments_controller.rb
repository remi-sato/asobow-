class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.post = @post
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_back fallback_location: post_path(@post),notice: "コメントしました"
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render :create, status: :unprocessable_entity
        end
        format.html do
          redirect_back fallback_location: post_path(@post), alert: "コメントを入力してください"
        end
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_back fallback_location: post_path(@post), notice: "コメントを削除しました"
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
