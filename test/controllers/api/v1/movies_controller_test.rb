require 'test_helper'

class Api::V1::MoviesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @movie = movies(:one)
    @user = users(:one)
    # sign_in @user

    # Obtain JWT token
    post user_session_url, params: { user: { email: @user.email, password: 'password' } }, as: :json
    @jwt_token = JSON.parse(response.body)['token']
  end

  def auth_headers
    { 'Authorization': "Bearer #{@jwt_token}" }
  end

  test "should get index" do
    get api_v1_movies_url, headers: auth_headers, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response
  end

  test "should show movie" do
    get api_v1_movie_url(@movie), headers: auth_headers, as: :json
    assert_response :success
  end

  test "should create movie" do
    assert_difference('Movie.count') do
      post api_v1_movies_url, params: { movie: { title: 'New Movie', publishing_year: 2021 } }, headers: auth_headers, as: :json
    end
    assert_response :created
  end

  test "should update movie" do
    patch api_v1_movie_url(@movie), params: { movie: { title: 'Updated Title' } }, headers: auth_headers, as: :json
    assert_response :success
  end

  test "should destroy movie" do
    assert_difference('Movie.count', -1) do
      delete api_v1_movie_url(@movie), headers: auth_headers, as: :json
    end
    assert_response :ok
  end

  test "should not create movie without title" do
    post api_v1_movies_url, params: { movie: { publishing_year: 2021 } }, headers: auth_headers, as: :json
    assert_response :unprocessable_entity
  end

  test "should not create movie without publishing year" do
    post api_v1_movies_url, params: { movie: { title: 'New Movie' } }, headers: auth_headers, as: :json
    assert_response :unprocessable_entity
  end

  test "should not access movies without authentication" do
    sign_out @user
    get api_v1_movies_url, as: :json
    assert_response :unauthorized
  end
end
