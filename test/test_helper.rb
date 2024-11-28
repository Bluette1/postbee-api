ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'
require 'database_cleaner-mongoid'

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  setup do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end
