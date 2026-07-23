require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      notification = build(:notification)

      expect(notification).to be_valid
    end

    it "通知したユーザーがいなければ登録できない" do
      notification = build(:notification, visitor: nil)

      expect(notification).not_to be_valid
    end

    it "通知を受け取るユーザーがいなければ登録できない" do
      notification = build(:notification, visited: nil)

      expect(notification).not_to be_valid
    end
  end
end
