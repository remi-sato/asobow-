require "rails_helper"

RSpec.describe "投稿", type: :system do
  let(:user) { create(:user) }

  it "投稿を作成できる" do
    visit login_path

    fill_in "メールアドレス", with: user.email_address
    fill_in "パスワード", with: "password"

    click_button "ログイン"

    expect(page).to have_link("ログアウト")

    visit new_post_path

    expect(page).to have_field("タイトル")

    fill_in "タイトル", with: "テスト"
    fill_in "場所名", with: "〇〇公園"
    fill_in "住所", with: "愛知県名古屋市"
    fill_in "本文", with: "本文"
    page.execute_script(<<~JS)
      document.querySelector("input[name='post[rating]']").value = "5";
    JS
    find("#post_category_park").choose
    find("#post_parking_unknown").choose
    find("#post_fee_unknown").choose

    click_button "投稿"

    expect(page).to have_content("投稿しました")
  end
end
