# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Admin.find_or_create_by!(email_address: "admin@sample.com") do |admin|
  admin.password = "password"
end

puts "管理者作成完了"

# テストユーザー
puts "ユーザーを作成中..."

users = [
  { name: "ピオまま", email_address: "pio@example.com" },
  { name: "トモ", email_address: "choco@example.com" },
  { name: "かおり", email_address: "toro@example.com" },
  { name: "長谷部", email_address: "pochi@example.com" },
  { name: "さくら", email_address: "sakura@example.com" }
]

users.each do |user_data|
  User.find_or_create_by!(email_address: user_data[:email_address]) do |user|
    user.name = user_data[:name]
    user.password = "demo-password"
    user.password_confirmation = "demo-password"
  end
end

puts "ユーザー5人の作成完了"

# 犬
puts "犬を作成中..."

dogs = [
  {
    owner: "pio@example.com",
    name: "ピオ",
    breed: "ビーグル",
    size: :medium,
    birthday: Date.new(2026, 3, 11),
    gender: :female,
    image: "pio.jpeg"
  },
  {
    owner: "choco@example.com",
    name: "チョコ",
    breed: "トイプードル",
    size: :small,
    birthday: Date.new(2023, 5, 10),
    gender: :female,
    image: "choco.jpeg"
  },
  {
    owner: "choco@example.com",
    name: "チーズ",
    breed: "トイプードル",
    size: :small,
    birthday: Date.new(2024, 1, 15),
    gender: :female,
    image: "cheese.jpeg"
  },
  {
    owner: "toro@example.com",
    name: "トロ",
    breed: "パピヨン",
    size: :small,
    birthday: Date.new(2022, 8, 1),
    gender: :female,
    image: "toro.jpeg"
  },
  {
    owner: "pochi@example.com",
    name: "ポチ",
    breed: "雑種",
    size: :large,
    birthday: Date.new(2021, 4, 15),
    gender: :male,
    image: "pochi.jpeg"
  },
  {
    owner: "sakura@example.com",
    name: "ひなた",
    breed: "ビーグル",
    size: :medium,
    birthday: Date.new(2024, 2, 20),
    gender: :male
  }
]

dogs.each do |dog_data|
  owner = User.find_by!(email_address: dog_data[:owner])

  dog = Dog.find_or_create_by!(
    name: dog_data[:name],
    user: owner
  ) do |new_dog|
    new_dog.breed = dog_data[:breed]
    new_dog.size = dog_data[:size]
    new_dog.birthday = dog_data[:birthday]
    new_dog.gender = dog_data[:gender]
  end

  next if dog_data[:image].blank?

  image_path = Rails.root.join(
    "db",
    "seeds",
    "images",
    "dogs",
    dog_data[:image]
  )

  if File.exist?(image_path) && !dog.image.attached?
    dog.image.attach(
      io: File.open(image_path),
      filename: dog_data[:image],
      content_type: Marcel::MimeType.for(image_path)
    )
  end
end

puts "犬6匹の作成完了"