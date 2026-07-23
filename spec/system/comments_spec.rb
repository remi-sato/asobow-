require "rails_helper"

RSpec.describe "コメント", type: :system do
  let(:user) { create(:user) }
  let(:target_post) { create(:post) }

  it "コメントできる" do
    visit login_path

    fill_in "メールアドレス", with: user.email_address
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).to have_link("ログアウト")

    visit post_path(target_post)

    find("#comment_body").set("テストコメント")
    click_button "コメントする"

    expect(page).to have_content("テストコメント", wait: 10)
    expect(target_post.comments.reload.exists?(body: "テストコメント")).to be true
  end
end
