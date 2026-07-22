require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      user = build(:user)

      expect(user).to be_valid
    end

    it "名前が空なら登録できない" do
      user = build(:user, name: nil)

      expect(user).not_to be_valid
    end

    it "メールアドレスが空なら登録できない" do
      user = build(:user, email_address: nil)

      expect(user).not_to be_valid
    end

    it "メールアドレスが重複していると登録できない" do
      create(:user, email_address: "test@example.com")
      user = build(:user, email_address: "test@example.com")

      expect(user).not_to be_valid
    end

    it "パスワードが6文字未満なら登録できない" do
      user = build(
        :user,
        password: "12345",
        password_confirmation: "12345"
      )

      expect(user).not_to be_valid
    end
  end
end