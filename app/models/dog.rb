class Dog < ApplicationRecord
  belongs_to :user
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

  def size_i18n
    I18n.t("enums.dog.size.#{size}")
  end

  def gender_i18n
    I18n.t("enums.dog.gender.#{gender}")
  end

end
