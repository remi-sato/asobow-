class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "通知購読ユーザーID: #{current_user.id}"
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
