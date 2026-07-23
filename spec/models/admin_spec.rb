require "rails_helper"

RSpec.describe Admin, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      expect(build(:admin)).to be_valid
    end

    it "メールアドレスが空なら登録できない" do
      expect(build(:admin, email_address: nil)).not_to be_valid
    end

    it "メールアドレスが重複すると登録できない" do
      admin = create(:admin)
      duplicate = build(:admin, email_address: admin.email_address)

      expect(duplicate).not_to be_valid
    end

    it "パスワードが空なら登録できない" do
      expect(build(:admin, password: nil)).not_to be_valid
    end
  end
end
