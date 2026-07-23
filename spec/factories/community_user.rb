FactoryBot.define do
  factory :community_user do
    association :user
    association :community

    status { :pending }
  end
end
