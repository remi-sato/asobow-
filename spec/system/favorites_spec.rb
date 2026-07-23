require "rails_helper"

RSpec.describe "いいね", type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  it "いいねできる" do
    visit login_path

    fill_in "メールアドレス", with: user.email_address
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    visit post_path(post)

    find("a[href='#{post_favorite_path(post)}']").click

    expect(page).to have_css(
      "a.btn-outline-danger[href='#{post_favorite_path(post)}']"
    )
    expect(post.favorites.reload.count).to eq(1)
  end
end
