# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < Devise::SessionsController
  include Authentication
  
  skip_before_action :authenticate_user, only: [:create]
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    token = current_token
    render json: { message: 'Signed in successfully.', user: resource, token: token }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end

  def current_token
    request.env['warden-jwt_auth.token']
  end
end