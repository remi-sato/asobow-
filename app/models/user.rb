class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :dogs, dependent: :destroy
  has_many :community_users, dependent: :destroy
  has_many :communities, through: :community_users

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

end
