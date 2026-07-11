class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  attr_accessor :tags_names

  has_many_attached :images
  
  validates :title, presence: true
  validates :body, presence: true
  validates :place_name, presence: true
  validates :address, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5}

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

end
