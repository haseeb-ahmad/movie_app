# app/channels/movie_channel.rb
class MovieChannel < ApplicationCable::Channel
  def subscribed
    # Stream from a specific movie channel based on the movie ID
    stream_for Movie.find(params[:movie_id])
  end

  def unsubscribed
    # Cleanup when unsubscribed
  end
end
