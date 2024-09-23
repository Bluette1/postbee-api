class AuthenticateToken
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    token = request.get_header('HTTP_AUTHORIZATION')&.split(' ')&.last

    if token && valid_token?(token)
      user = token_record?(token).user

      env['CURRENT_USER'] = user if user
    end

    @app.call(env)
  end

  private

  def token_record?(token)
    Token.where(access_token: token).first
  end

  def valid_token?(token)
    Token.valid?(token_record?(token))
  end
end
