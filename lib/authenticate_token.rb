# # lib/authenticate_token.rb

class AuthenticateToken
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    token = request.get_header('HTTP_AUTHORIZATION')&.split(' ')&.last

    return unless token && valid_token?(token)

    user = User.find_by(token:)
    env['CURRENT_USER'] = user if user
    @app.call(env)
  end

  private

  def valid_token?(token)
    # Check if the token exists in the database and if it's valid
    Token.where(access_token: token).exists? && Token.valid?(token)
  end
end
