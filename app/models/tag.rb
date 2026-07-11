class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: true

  def self.looks(search, word)
    if search == "perfect_match"
      where(name: word)
    elsif search == "forword_match"
      where("name LIKE ?", "#{word}%")
    elsif search == "backword_match"
      where("name LILE?", "%#{word}")
    else
      where("name LIKE?", "%#{word}%")
    end
  end
end
