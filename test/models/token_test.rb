require 'test_helper'

class TokenTest < Minitest::Test
  def setup
    super
    @user = User.create!(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  def test_generate_tokens
    tokens = Token.generate_tokens(@user)

    assert_instance_of Hash, tokens # Change to Hash
    refute_empty tokens

    assert_instance_of String, tokens[:access_token]
    assert_instance_of String, tokens[:refresh_token]
  end

  def teardown
    super
    User.delete_all
    Token.delete_all
  end
end
