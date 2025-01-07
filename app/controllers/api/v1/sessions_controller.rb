# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Signed in successfully.', user: resource }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end