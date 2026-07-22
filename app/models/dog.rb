class Dog < ApplicationRecord
  belongs_to :user
  has_many :post_dogs, dependent: :destroy
  has_many :posts, through: :post_dogs
  has_many :community_user_dogs, dependent: :destroy
  has_many :community_users, through: :community_user_dogs
  
  has_one_attached :image

  enum :size, {
    small: 0,
    medium: 1,
    large: 2
  }

  enum :gender, {
    male: 0,
    female: 1
  }

  validates :name, presence: true
  validates :breed, presence: true
  validates :size, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true

end
