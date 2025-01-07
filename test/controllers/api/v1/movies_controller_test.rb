require 'test_helper'

class Api::V1::MoviesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @movie = movies(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get api_v1_movies_url, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_not_nil body
  end

  test "should show movie" do
    get api_v1_movie_url(@movie), as: :json
    assert_response :success
  end

  test "should create movie" do
    assert_difference('Movie.count') do
      post api_v1_movies_url, params: { movie: { title: 'New Movie', publishing_year: 2021 } }, as: :json
    end
    assert_response :created
  end

  test "should update movie" do
    patch api_v1_movie_url(@movie), params: { movie: { title: 'Updated Title' } }, as: :json
    assert_response :success
  end

  test "should destroy movie" do
    assert_difference('Movie.count', -1) do
      delete api_v1_movie_url(@movie), as: :json
    end
    assert_response :ok
  end
end
