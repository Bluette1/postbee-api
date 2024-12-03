require 'database_cleaner-mongoid'
require 'rack/test'
require 'json'
require_relative '../../config/environment'

DatabaseCleaner.strategy = :deletion
# Cucumber::Rails::Database.javascript_strategy = :deletion

Before do
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end