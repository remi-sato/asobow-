class FavoritesController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
  favorite = current_user.favorites.create(post: @post)

  Rails.logger.info "favorite.persisted?: #{favorite.persisted?}"
  Rails.logger.info "いいねしたユーザーID: #{current_user.id}"
  Rails.logger.info "投稿者ユーザーID: #{@post.user.id}"

  if favorite.persisted? && current_user != @post.user
    notification = Notification.create!(
      visitor: current_user,
      visited: @post.user,
      post: @post,
      action: :like
    )

    Rails.logger.info "通知送信先ユーザーID: #{@post.user.id}"

    NotificationsChannel.broadcast_to(
      @post.user,
      {
        message: "#{current_user.name}さんがいいねしました",
        notification_id: notification.id
      }
    )
  end

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_back fallback_location: post_path(@post) }
  end
end

  def destroy
    favorite = current_user.favorites.find_by(post: @post)
    favorite&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html{ redirect_back fallback_location: post_path(@post) }
    end
  end

  private

  def set_post
     @post = Post.find(params[:post_id])
  end
end
