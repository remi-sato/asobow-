require "rails_helper"

RSpec.describe Dog, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      dog = build(:dog)

      expect(dog).to be_valid
    end

    it "名前が空なら登録できない" do
      dog = build(:dog, name: nil)

      expect(dog).not_to be_valid
    end

    it "犬種が空なら登録できない" do
      dog = build(:dog, breed: nil)

      expect(dog).not_to be_valid
    end

    it "サイズが空なら登録できない" do
      dog = build(:dog, size: nil)

      expect(dog).not_to be_valid
    end

    it "誕生日が空なら登録できない" do
      dog = build(:dog, birthday: nil)

      expect(dog).not_to be_valid
    end

    it "性別が空なら登録できない" do
      dog = build(:dog, gender: nil)

      expect(dog).not_to be_valid
    end
  end
end
