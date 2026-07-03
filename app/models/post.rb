class Post < ApplicationRecord
  belongs_to :user
  # has_many :favorites, dependent: :destroy
  # has_many :comments, dependent: :destroy
  # has_many :post_tags, dependent: :destroy
  # has_many :tags, through: :post_tags

  has_many_attached :images
  
  validates :title, presence: true
  validates :body, presence: true
  validates :place_name, presence: true
  validates :address, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5}
end
