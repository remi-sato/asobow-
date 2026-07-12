class CommunityUser < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }
end
