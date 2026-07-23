require "rails_helper"

RSpec.describe "コミュニティ", type: :system do
  let(:user) { create(:user) }

  it "コミュニティを作成できる" do
    visit login_path

    fill_in "メールアドレス", with: user.email_address
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).to have_link("ログアウト")

    visit new_community_path

    fill_in "コミュニティ名", with: "ビーグル好き集まれ！"
    fill_in "コミュニティ紹介", with: "ビーグルと遊びたい人向けのコミュニティです。"
    fill_in "ルール", with: "みんな仲良く利用しましょう。"

    click_button "作成"

    expect(page).not_to have_current_path(new_community_path, wait: 10)
    expect(page).to have_content("ビーグル好き集まれ！", wait: 10)

    expect(
      Community.exists?(
        name: "ビーグル好き集まれ！",
        user: user
      )
    ).to be true
  end
end
