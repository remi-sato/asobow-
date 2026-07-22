class Community < ApplicationRecord
  belongs_to :user

  has_many :community_users, dependent: :destroy
  has_many :users, through: :community_users

  has_many :community_user_dogs, through: :community_users
  has_many :participating_dogs, through: :community_user_dogs, source: :dog

  has_many :notifications, dependent: :destroy

  validates :name, presence: true
  validates :introduction, presence: true
  validates :rules, presence: true

  def self.looks(search, word)
    if search == "perfect_match"
      where(name: word)
    elsif search == "forward_match"
      where("name LIKE ?", "#{word}%")
    elsif search == "backward_match"
      where("name LIKE ?", "%#{word}")
    else
      where("name LIKE ?", "%#{word}%")
    end
  end

  def create_notification_join_request!(visitor)
    notification = Notification.create!(
      visitor: visitor,
      visited: user,
      community: self,
      action: :join_request
    )
    NotificationsChannel.broadcast_to(
      user,
      {
        message: "#{visitor.name}さんから参加申請が届きました",
        notification_id: notification.id
      }
    )
  end

  def create_notification_event!(visitor, community_user)
    notification = Notification.create!(
        visitor: visitor,
        visited: community_user.user,
        community: self,
        action: :event
      )

      NotificationsChannel.broadcast_to(
        community_user.user,
        {
          message: "#{name}からイベントのお知らせが届きました",
          notification_id: notification.id
        }
      )
  end
end
