# app/serializers/movie_serializer.rb
class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :publishing_year, :poster_url, :status, :video_url

  def poster_url
    object.poster.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.poster, host: Rails.application.routes.default_url_options[:host]) : nil
  end

  def video_url
    object.video.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.video, host: Rails.application.routes.default_url_options[:host]) : nil
  end
end
