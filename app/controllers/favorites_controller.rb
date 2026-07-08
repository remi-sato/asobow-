class FavoritesController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    current_user.favorites.create(post: @post)
    redirect_back fallback_location: post_path(@post)
  end

  def destroy
    favorite = current_user.favorites.find_by(post: @post)
    favorite&.destroy
    redirect_back fallback_location: post_path(@post)
  end

  private

  def set_post
     @post = Post.find(params[:post_id])
  end
end
