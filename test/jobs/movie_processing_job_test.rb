require 'test_helper'

class MovieProcessingJobTest < ActiveJob::TestCase
  setup do
    @movie = movies(:one)
  end

  test "should process movie" do
    assert_enqueued_with(job: MovieProcessingJob, args: [@movie.id]) do
      MovieProcessingJob.perform_later(@movie.id)
    end
  end
end
