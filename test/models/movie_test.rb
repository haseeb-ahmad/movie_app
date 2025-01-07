require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "should not save movie without title" do
    movie = Movie.new(publishing_year: 2021)
    assert_not movie.save, "Saved the movie without a title"
  end

  test "should not save movie without publishing year" do
    movie = Movie.new(title: 'Test Movie')
    assert_not movie.save, "Saved the movie without a publishing year"
  end

  test "should save movie with valid title and publishing year" do
    movie = Movie.new(title: 'Test Movie', publishing_year: 2021)
    assert movie.save, "Failed to save the movie with valid title and publishing year"
  end
end
