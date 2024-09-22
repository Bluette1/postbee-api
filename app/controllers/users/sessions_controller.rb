class Users::SessionsController < Devise::SessionsController
  def create
    auth_params = params.require(:user).permit(:email, :password)

    self.resource = User.find_for_database_authentication(email: auth_params[:email])

    if resource&.valid_password?(auth_params[:password])
      tokens = resource.generate_access_tokens
      render json: { user: resource, access_token: tokens[:access_token], refresh_token: tokens[:refresh_token] },
             status: :created
    else
      render json: { errors: ['Invalid credentials'] }, status: :unauthorized
    end
  end

  def destroy
    email = params.dig(:user, :email)

    if email
      resource = User.find_by(email:)
      if resource
        resource.invalidate_tokens
        render json: { message: 'Logged out' }, status: :ok
      else
        render json: { errors: ['User not found'] }, status: :not_found
      end
    else
      render json: { errors: ['Email not provided'] }, status: :bad_request
    end
  end

  def respond_to(*args)
    # Override respond_to to disable it for this controller
    # This effectively makes sure no format-based responses are attempted
    # No action is needed, as we handle responses manually.
  end
end
