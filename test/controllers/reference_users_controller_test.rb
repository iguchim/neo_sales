require 'test_helper'

class ReferenceUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reference_user = reference_users(:one)
  end

  test "should get index" do
    get reference_users_url
    assert_response :success
  end

  test "should get new" do
    get new_reference_user_url
    assert_response :success
  end

  test "should create reference_user" do
    assert_difference('ReferenceUser.count') do
      post reference_users_url, params: { reference_user: { refer_id: @reference_user.refer_id, referred_id: @reference_user.referred_id } }
    end

    assert_redirected_to reference_user_url(ReferenceUser.last)
  end

  test "should show reference_user" do
    get reference_user_url(@reference_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_reference_user_url(@reference_user)
    assert_response :success
  end

  test "should update reference_user" do
    patch reference_user_url(@reference_user), params: { reference_user: { refer_id: @reference_user.refer_id, referred_id: @reference_user.referred_id } }
    assert_redirected_to reference_user_url(@reference_user)
  end

  test "should destroy reference_user" do
    assert_difference('ReferenceUser.count', -1) do
      delete reference_user_url(@reference_user)
    end

    assert_redirected_to reference_users_url
  end
end
