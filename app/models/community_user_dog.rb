class CommunityUserDog < ApplicationRecord
  belongs_to :community_user
  belongs_to :dog

  validates :dog_id, uniqueness: { scope: :community_user_id }
end
