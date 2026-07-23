FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "テストユーザー#{n}" }
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    introduction { "テスト用の自己紹介です" }
    is_active { true }
  end
end
