require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      expect(build(:tag)).to be_valid
    end

    it "名前が空なら登録できない" do
      expect(build(:tag, name: nil)).not_to be_valid
    end

    it "名前が重複すると登録できない" do
      tag = create(:tag)
      duplicate = build(:tag, name: tag.name)

      expect(duplicate).not_to be_valid
    end
  end
end
