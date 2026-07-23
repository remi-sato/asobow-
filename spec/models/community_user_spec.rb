require "rails_helper"

RSpec.describe CommunityUser, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      community_user = build(:community_user)

      expect(community_user).to be_valid
    end

    it "同じユーザーは同じコミュニティに重複して登録できない" do
      community_user = create(:community_user)

      duplicate = build(
        :community_user,
        user: community_user.user,
        community: community_user.community
      )

      expect(duplicate).not_to be_valid
    end
  end
end
