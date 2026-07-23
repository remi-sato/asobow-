require "rails_helper"

RSpec.describe "コミュニティ参加申請", type: :system do
  let(:owner) { create(:user) }
  let(:applicant) { create(:user) }
  let(:community) { create(:community, user: owner) }

  it "コミュニティに参加申請できる" do
    visit login_path

    fill_in "メールアドレス", with: applicant.email_address
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).to have_link("ログアウト")

    visit community_path(community)

    click_link "参加申請する"

    # 参加犬を選ぶ画面なら、ここで選択
    # 例:
    # check "ピオ"

    click_button "参加申請する"

    expect(page).to have_content("参加申請中です", wait: 10)

    expect(
      CommunityUser.exists?(
        user: applicant,
        community: community,
        status: :pending
      )
    ).to be true
  end
end
