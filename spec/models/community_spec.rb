require "rails_helper"

RSpec.describe Community, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      community = build(:community)

      expect(community).to be_valid
    end

    it "名前が空なら登録できない" do
      community = build(:community, name: nil)

      expect(community).not_to be_valid
    end

    it "紹介文が空なら登録できない" do
      community = build(:community, introduction: nil)

      expect(community).not_to be_valid
    end

    it "ルールが空なら登録できない" do
      community = build(:community, rules: nil)

      expect(community).not_to be_valid
    end
  end
end