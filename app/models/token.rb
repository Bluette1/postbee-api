# app/models/token.rb
class Token
  include Mongoid::Document

  field :access_token, type: String
  field :refresh_token, type: String
  field :expires_at, type: DateTime

  belongs_to :user

  # Generate new access and refresh tokens
  def self.generate_tokens(user)
    access_token = SecureRandom.hex(10)
    refresh_token = SecureRandom.hex(10)
    expires_at = 1.hour.from_now

    user.tokens.create(
      access_token:,
      refresh_token:,
      expires_at:
    )

    { access_token:, refresh_token: }
  end

  def self.valid?(token)
    token.expires_at > Time.current
  end

  # Custom method to check if a token exists
  def self.token_exists?(token)
    where(access_token: token).exists?
  end
end
