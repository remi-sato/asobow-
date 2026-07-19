class Notification < ApplicationRecord
  belongs_to :visitor, class_name: "User"
  belongs_to :visited, class_name: "User"
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :community, optional: true

  enum :action, {
    like: 0,
    comment: 1,
    join_request: 2,
    approved: 3,
    rejected: 4,
    event: 5
  }
end
