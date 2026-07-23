require "rails_helper"

RSpec.describe CommunityUserDog, type: :model do
  describe "バリデーション" do
    it "正しい情報なら登録できる" do
      expect(build(:community_user_dog)).to be_valid
    end

    it "同じ参加情報に同じ犬は登録できない" do
      create(:community_user_dog)

      duplicate = build(
        :community_user_dog,
        community_user: CommunityUserDog.first.community_user,
        dog: CommunityUserDog.first.dog
      )

      expect(duplicate).not_to be_valid
    end
  end
end
