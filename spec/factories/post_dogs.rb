FactoryBot.define do
  factory :post_dog do
    association :post
    association :dog
  end
end
