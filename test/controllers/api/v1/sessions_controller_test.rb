# test/controllers/api/v1/sessions_controller_test.rb
require 'test_helper'

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should sign in user with valid credentials" do
    post user_session_url, params: { user: { email: @user.email, password: 'password' } }, as: :json
    assert_response :success
    assert_includes @response.body, 'Signed in successfully.'
  end

  test "should not sign in user with invalid credentials" do
    post user_session_url, params: { user: { email: @user.email, password: 'wrongpassword' } }, as: :json
    assert_response :unauthorized
  end

  test "should sign out user" do
    delete destroy_user_session_url, as: :json
    assert_response :no_content
  end
end