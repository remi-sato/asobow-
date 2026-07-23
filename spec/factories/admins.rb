FactoryBot.define do
  factory :admin do
    sequence(:email_address) { |n| "admin#{n}@sample.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
