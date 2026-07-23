FactoryBot.define do
  factory :comment do
    association :user
    association :post

    body { "今度行ってみます" }
  end
end
