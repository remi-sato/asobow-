class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: [:show, :destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "投稿を削除しました" 
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

end

