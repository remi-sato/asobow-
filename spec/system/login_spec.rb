require "rails_helper"

RSpec.describe "ログイン", type: :system do
  let(:user) { create(:user) }

  it "ログインできる" do
    visit login_path

    fill_in "メールアドレス", with: user.email_address
    fill_in "パスワード", with: "password"

    click_button "ログイン"

    expect(page).to have_content("ログインしました")
  end
end
