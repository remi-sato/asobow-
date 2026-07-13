require "test_helper"

class CommunityNoticeControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get community_notice_new_url
    assert_response :success
  end

  test "should get create" do
    get community_notice_create_url
    assert_response :success
  end

  test "should get show" do
    get community_notice_show_url
    assert_response :success
  end
end
