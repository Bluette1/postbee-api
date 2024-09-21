# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    tokens = resource.generate_access_tokens

    render json: { user: resource, access_token: tokens[:access_token], refresh_token: tokens[:refresh_token] }, status: :created
  rescue StandardError
    render json: { errors: ['Invalid credentials'] }, status: :unauthorized
  end

  def destroy
    resource = User.find_by(email: params[:user][:email])
    resource.invalidate_tokens if resource
    sign_out(resource_name)

    render json: { message: 'Logged out' }, status: :ok
  end

  # New action for refreshing access token
  def refresh
    token = params[:refresh_token]
    user = Token.where(refresh_token: token).first&.user

    if user && Token.valid?(Token.where(refresh_token: token).first)
      tokens = user.generate_access_tokens
      render json: { access_token: tokens[:access_token], refresh_token: tokens[:refresh_token] }, status: :ok
    else
      render json: { errors: ['Invalid or expired refresh token'] }, status: :unauthorized
    end
  end
end
