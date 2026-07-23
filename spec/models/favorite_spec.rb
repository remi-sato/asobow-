RSpec.describe Favorite, type: :model do
  it "有効なFactoryを持つこと" do
    expect(build(:favorite)).to be_valid
  end

  it "同じユーザーは同じ投稿に二重いいねできない" do
    create(:favorite)
    duplicate = build(:favorite,
      user: Favorite.first.user,
      post: Favorite.first.post
    )

    expect(duplicate).not_to be_valid
  end
end
