require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      comment = build(:comment)

      expect(comment).to be_valid
    end

    it "本文が空なら登録できない" do
      comment = build(:comment, body: nil)

      expect(comment).not_to be_valid
    end
  end
end
