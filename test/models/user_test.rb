require 'test_helper'

class UserTest < Minitest::Test
  def setup
    super
    @user = User.new(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  def test_valid_user
    assert @user.valid?
  end

  def test_email_presence
    @user.email = nil
    refute @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  def test_email_uniqueness
    @user.save
    duplicate_user = User.new(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
    refute duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], 'has already been taken'
  end

  def test_generate_access_tokens
    @user.save
    assert_empty @user.tokens
    @user.generate_access_tokens
    refute_empty @user.tokens
  end

  def test_invalidate_tokens
    @user.save
    @user.generate_access_tokens
    refute_empty @user.tokens
    @user.invalidate_tokens
    assert_empty @user.tokens
  end

  def test_refresh_tokens
    @user.save
    @user.generate_access_tokens
    original_tokens = @user.tokens.to_a
    @user.refresh_tokens
    refute_equal original_tokens, @user.tokens.to_a
    refute_empty @user.tokens
  end

  def teardown
    super
    User.delete_all
    Token.delete_all
  end
end
