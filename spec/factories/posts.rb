FactoryBot.define do
  factory :post do
    association :user

    title { "テスト投稿" }
    place_name { "〇〇公園" }
    address { "愛知県名古屋市" }
    latitude { 35.1815 }
    longitude { 136.9066 }
    rating { 5 }
    body { "いい公園です" }

    category { :park }
    parking { :available }
    fee { :free }
  end
end
