# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    token, _options = ActionController::HttpAuthentication::Token.token_and_options(request)
    user_id = decode_jwt_token(token)
    @current_user = User.find_by(id: user_id)

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def decode_jwt_token(token)
    JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key], true, { algorithm: 'HS256' })[0]['sub']
  rescue JWT::DecodeError
    nil
  end
end