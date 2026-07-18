class PostDog < ApplicationRecord
  belongs_to :post
  belongs_to :dog

  validates :dog_id, uniqueness: { scope: :post_id }
end
