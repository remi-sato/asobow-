FactoryBot.define do
  factory :community_user_dog do
    association :community_user
    association :dog
  end
end
