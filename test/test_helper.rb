ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'
require 'database_cleaner-mongoid'

Mongoid.load!('config/mongoid.yml', :test)

def print_latest_log_entries(lines = 50)
  log_file_path = Rails.root.join('log', 'test.log') # Path to the test.log file
  if File.exist?(log_file_path)
    puts File.readlines(log_file_path).last(lines) # Read and print the last 'lines' entries
  else
    puts 'Log file not found.'
  end
end

module ActiveSupport
  class TestCase
    include Devise::Test::IntegrationHelpers

    setup do
      DatabaseCleaner.strategy = :deletion
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end
  end
end

# Set default host for URL generation
Rails.application.routes.default_url_options[:host] = 'localhost:3000'
