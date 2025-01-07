# app/controllers/api/v1/movies_controller.rb
class Api::V1::MoviesController < ApplicationController
  include Paginate

  before_action :authenticate_user!
  before_action :find_movie, only: [:show, :update, :destroy]

  # GET /api/v1/movies
  def index
    movies = paginate(Movie.all)
    render json: movies, each_serializer: MovieSerializer, meta: {
      total_pages: movies.total_pages,
      total_count: movies.total_count,
      current_page: movies.current_page,
      per_page: movies.limit_value
    }, root: "movies"    
  end
  

  # GET /api/v1/movies/:id
  def show
    render json: @movie, status: :ok
  end

  # POST /api/v1/movies
  def create
    @movie = Movie.new(movie_params.except(:video))
  
    if @movie.save
      # Pass file metadata to the background job
      debugger
      file = movie_params[:video]
      file_path = file.tempfile.path
      file_metadata = { filename: file.original_filename, content_type: file.content_type }
  
      MovieProcessingJob.perform_later(@movie.id, file_path, file_metadata)
  
      render json: {
        movie: MovieSerializer.new(@movie),
        message: 'Movie uploaded successfully and is being processed!'
      }, status: :created
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/movies/:id
  def update
    if @movie.update(movie_params)
      render json: { movie: @movie, message: 'Movie updated successfully!' }, status: :ok
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/movies/:id
  def destroy
    @movie.destroy
    render json: { message: 'Movie deleted successfully!' }, status: :ok
  end

  private

  def find_movie
    @movie = Movie.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Movie not found' }, status: :not_found
  end

  def movie_params
    params.require(:movie).permit(:title, :publishing_year, :video)
  end
end
