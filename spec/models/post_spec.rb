require "rails_helper"

RSpec.describe Post, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      user = build(:post)

      expect(user).to be_valid
    end

    it "タイトルが空なら登録できない" do
      post = build(:post, title: nil)

      expect(post).not_to be_valid
    end

    it "場所名が空なら登録できない" do
      post = build(:post, place_name: nil)

      expect(post).not_to be_valid
    end

    it "住所が空なら登録できない" do
      post = build(:post, address: nil)

      expect(post).not_to be_valid
    end

    it "評価が空なら登録できない" do
      post = build(:post, rating: nil)

      expect(post).not_to be_valid
    end
  end
end
