ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'
require 'database_cleaner-mongoid'

class Minitest::Test
  def setup
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
