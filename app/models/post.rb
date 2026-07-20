class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :post_dogs, dependent: :destroy
  has_many :dogs, through: :post_dogs
  has_many :notifications, dependent: :destroy

  has_many_attached :images

  attr_accessor :tags_names

  enum :category, {
    park: 0,
    dog_run: 1,
    other: 2
  }, prefix: true

  enum :parking, {
    available: 0,
    unavailable: 1,
    unknown: 2
  }, prefix: true

  enum :fee, {
    free: 0,
    paid: 1,
    unknown: 2
  }, prefix: true
  
  validates :title, presence: true
  validates :place_name, presence: true
  validates :address, presence: true
  validates :rating, inclusion: { in: 1..5, message: "を選択してください"}
  validates :category, presence: true
  validates :parking, presence: true
  validates :fee, presence: true

  scope :by_category, ->(category) {
    where(category: category) if category.present?
  }

  scope :by_parking, ->(parking) {
    where(parking: parking) if parking.present?
  }

  scope :by_fee, ->(fee) {
    where(fee: fee) if fee.present?
  }

  def self.looks(search, word)
    if search == "perfect_match"
      where("place_name LIKE ? OR address LIKE ?", word, word)
    elsif search == "forward_match"
      where("place_name LIKE ? OR address LIKE ?", "#{word}%", "#{word}%")
    elsif search == "backward_match"
      where("place_name LIKE ? OR address LIKE ?", "%#{word}", "%#{word}")
    else
      where("place_name LIKE ? OR address LIKE ?", "%#{word}%", "%#{word}%")
    end
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def create_notification_like!(visitor)
    return if visitor == user

    notification = Notification.create!(
      visitor: visitor,
      visited: user,
      post: self,
      action: :like
    )
  
    NotificationsChannel.broadcast_to(
      user,
      {
        message: "#{visitor.name}さんがいいねしました",
        notification_id: notification.id
      }
    )
  end

  def create_notification_comment!(visitor, comment)
    return if visitor == user

    notification = Notification.create!(
      visitor: visitor,
      visited: user,
      post: self,
      comment: comment,
      action: :comment
    )

    NotificationsChannel.broadcast_to(
      user,
      {
        message: "#{visitor.name}さんがコメントしました",
        notification_id: notification.id
      }
    )
  end

end
