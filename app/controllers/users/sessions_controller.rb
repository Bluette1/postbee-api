module Users
  class SessionsController < Devise::SessionsController
    before_action :authenticate_user!, only: [:destroy]
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
      if current_user
        current_user.invalidate_tokens
        render json: { message: 'Logged out' }, status: :ok
      else
        render json: { errors: ['User not found'] }, status: :not_found
      end
    end

    def refresh
      refresh_token = params[:refresh_token]
      user = Token.where(refresh_token:).first&.user

      if user && Token.valid?(Token.where(refresh_token:).first)
        tokens = user.refresh_tokens
        render json: { access_token: tokens[:access_token], refresh_token: tokens[:refresh_token] }, status: :ok
      else
        render json: { errors: ['Invalid or expired refresh token'] }, status: :unauthorized
      end
    end

    def respond_to(*args)
      # Override respond_to to disable it for this controller
      # This effectively makes sure no format-based responses are attempted
      # No action is needed, as we handle responses manually.
    end

    private

    def current_user
      @current_user ||= authenticate_user!
    end

    def authenticate_user!
      if request.env['CURRENT_USER']
        @current_user = request.env['CURRENT_USER']
      else
        render json: { errors: ['Unauthorized'] }, status: :unauthorized
      end
    end

    def valid_token?(token)
      token_record = Token.where(access_token: token).first
      Token.valid?(token_record)
    end
  end
end
