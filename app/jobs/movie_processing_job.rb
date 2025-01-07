# app/jobs/movie_processing_job.rb
class MovieProcessingJob < ApplicationJob
  queue_as :default

  def perform(movie_id, file_path, file_metadata)
    movie = Movie.find(movie_id)

    # Attach the video using the provided file metadata
    attach_video(movie, file_path, file_metadata)

    return unless movie.video.attached?

    # Update movie status to "processing"
    movie.update(status: :processing)

    begin
      process_video(movie)
      movie.update(status: :processed) # Update status to "processed" when successful
    rescue => e
      movie.update(status: :failed) # Update status to "failed" on error
      Rails.logger.error("Error processing video for movie #{movie.id}: #{e.message}")
    end
  end

  private

  def attach_video(movie, file_path, file_metadata)
    return unless file_path.present?

    # Attach the file using Active Storage
    movie.video.attach(
      io: File.open(file_path),
      filename: file_metadata[:filename] || "video_#{Time.now.to_i}",
      content_type: file_metadata[:content_type]
    )
  end

  def process_video(movie)
    video = movie.video

    if video.attached?
      # Download the video content into memory
      video_file = video.download

      # Create a temporary file for the poster image
      poster_path = Rails.root.join('tmp', "#{movie.id}_poster.jpg").to_s

      Tempfile.create(['video', '.mp4']) do |tmp_video|
        tmp_video.binmode
        tmp_video.write(video_file)
        tmp_video.rewind

        # Use FFmpeg to extract the poster image
        movie_video = FFMPEG::Movie.new(tmp_video.path)
        movie_video.screenshot(poster_path, seek_time: 5, resolution: '640x360')

        # Attach the poster to the movie
        movie.poster.attach(io: File.open(poster_path), filename: "#{movie.id}_poster.jpg", content_type: 'image/jpeg')

        # Clean up the temporary poster file
        File.delete(poster_path) if File.exist?(poster_path)
      end
    else
      Rails.logger.error "No video file attached to movie #{movie.id}"
    end
  end
end
