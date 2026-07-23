FactoryBot.define do
  factory :community do
    association :user

    name { "愛知ビーグル会" }
    introduction { "愛知在住のビーグルであつまりましょう" }
    rules { "飼い主１人に犬２匹まで" }
  end
end
