FactoryBot.define do
  factory :dog do
    association :user

    name { "ピオ" }
    breed { "ビーグル" }
    size { :medium }
    birthday { Date.new(2026, 3, 11) }
    gender { :female }
  end
end
