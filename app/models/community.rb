class Community < ApplicationRecord
  belongs_to :user

  has_many :community_users, dependent: :destroy
  has_many :users, through: :community_users

  validates :name, presence: true
  validates :introduction, presence: true
  validates :rules, presence: true
end
