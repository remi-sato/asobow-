require "rails_helper"

RSpec.describe PostDog, type: :model do
  describe "バリデーション" do
    it "同じ投稿に同じ犬を重複して登録できない" do
      post_dog = create(:post_dog)

      duplicate = build(
        :post_dog,
        post: post_dog.post,
        dog: post_dog.dog
      )

      expect(duplicate).not_to be_valid
    end
  end
end
