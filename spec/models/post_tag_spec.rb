require "rails_helper"

RSpec.describe PostTag, type: :model do
  describe "バリデーション" do
    it "同じ投稿に同じタグを重複して登録できない" do
      post_tag = create(:post_tag)

      duplicate = build(
        :post_tag,
        post: post_tag.post,
        tag: post_tag.tag
      )

      expect(duplicate).not_to be_valid
    end
  end
end
