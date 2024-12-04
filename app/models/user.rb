# app/models/user.rb
class User
  include Mongoid::Document
  include Devise::Models

  field :email, type: String
  field :encrypted_password, type: String

  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true

  has_many :tokens, class_name: 'Token'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  def generate_access_tokens
    tokens.delete_all # Remove old tokens
    Token.generate_tokens(self)
  end

  def invalidate_tokens
    tokens.delete_all
  end

  def refresh_tokens
    generate_access_tokens # Generate new tokens
  end
end
