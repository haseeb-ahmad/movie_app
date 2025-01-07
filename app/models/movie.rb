# app/models/movie.rb
class Movie < ApplicationRecord
  has_one_attached :poster
  has_one_attached :video

  validates :title, :publishing_year, presence: true
  validate :poster_size

  enum :status, [ :pending, :processing, :processed, :failed ]

  # Attach video and trigger background processing after video is uploaded
  after_create :enqueue_video_processing, if: :video_attached?
  

  private

  def video_attached?
    video.attached?
  end

  def enqueue_video_processing
    MovieProcessingJob.perform_later(self.id)
  end

  def poster_size
    
    if poster.attached? && poster.byte_size > 5.megabytes
      errors.add(:poster, 'is too big. Maximum size is 5MB.')
    end
  end
end
