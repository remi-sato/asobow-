class Admin::PostsController < ApplicationController
  layout "admin"
  before_action :require_admin_login
  before_action :set_post, only: [:show, :destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
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

