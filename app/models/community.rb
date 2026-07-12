class Community < ApplicationRecord
  belongs_to :user

  has_many :community_users, dependent: :destroy
  has_many :users, through: :community_users

  validates :name, presence: true
  validates :introduction, presence: true
  validates :rules, presence: true

  def self.looks(search,word)
    if search == "perfect_match"
      where(name: word)
    elsif search == "forward_match"
      where("name LIKE ?", "#{word}%")
    elsif search == "backward_match"
      where("name LIKE ?", "#%{word}")
    else search == "partial_match"
      where("name LIKE ?", "%#{word}%")
    end
  end
end
