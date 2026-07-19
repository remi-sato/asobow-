class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.passive_notifications.includes(:visitor, :post, :comment, :community).order(created_at: :desc)
    @notifications.where(checked: false).update_all(checked: true)
  end
end
