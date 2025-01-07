# app/jobs/movie_processing_job.rb
class MovieProcessingJob < ApplicationJob
  queue_as :default

  def perform(movie_id)
    
    movie = Movie.find(movie_id)
    return unless movie.video.attached?

    # Update movie status to "processing"
    movie.update(status: :processing)

    begin
      process_video(movie)
      movie.update(status: :processed)  # Update to "processed" when finished
    rescue => e
      movie.update(status: :failed)  # Update to "failed" if there's an error
      # MovieChannel.broadcast_to(movie, { status: movie.status, movie_id: movie.id })
      Rails.logger.error("Error processing video for movie #{movie.id}: #{e.message}")
    end
  end

  private

  
  
  def process_video(movie)
    # Download video file to memory (use temporary file if you want to store on disk)
    video = movie.video
  
    # Check if video is attached
    if video.attached?
      # Download the video content into memory (returns an IO object)
      video_file = video.download
  
      # Create a temporary file to store the poster image
      poster_path = Rails.root.join('tmp', "#{movie.id}_poster.jpg").to_s # Convert to string
  
      # Use Tempfile to handle the video file as binary data
      Tempfile.create(['video', '.mp4']) do |tmp_video|
        # Write the video binary data to the temporary file
        tmp_video.binmode  # Ensure that it's treated as binary
        tmp_video.write(video_file) # Write the downloaded content to the temp file
        tmp_video.rewind # Rewind the file to the beginning for FFMpeg
  
        # Use FFMpeg to extract the poster image
        movie_video = FFMPEG::Movie.new(tmp_video.path) # Make sure tmp_video.path is a string
        movie_video.screenshot(poster_path, seek_time: 5, resolution: '640x360')
  
        # Attach the poster to the movie record
        movie.poster.attach(io: File.open(poster_path), filename: "#{movie.id}_poster.jpg", content_type: 'image/jpeg')
  
        # Optionally clean up the temporary poster file
        File.delete(poster_path) if File.exist?(poster_path)
      end
  
      # Broadcast the status of the movie processing (via ActionCable)
      # MovieChannel.broadcast_to(movie, { status: movie.status, movie_id: movie.id })
  
    else
      Rails.logger.error "No video file attached to movie #{movie.id}"
    end
  end
  
   
end
