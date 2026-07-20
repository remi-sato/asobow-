class CommunityUser < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  validates :user_id, uniqueness: { scope: :community_id }

  def create_notification_approved!(visitor)
    notification = Notification.create!(
      visitor: visitor,
      visited: user,
      community: community,
      action: :approved
    )
    NotificationsChannel.broadcast_to(
      user,
      {
        message: "#{community.name}への参加が承認されました",
        notification_id: notification.id
      }
    )
  end

  def create_notification_rejected!(visitor)
    notification = Notification.create!(
      visitor: visitor,
      visited: user,
      community: community,
      action: :rejected
    )
    NotificationsChannel.broadcast_to(
      user,
      {
        message: "#{community.name}への参加が拒否されました",
        notification_id: notification.id
      }
    )
  end

end
