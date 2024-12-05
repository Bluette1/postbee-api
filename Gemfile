source 'https://rubygems.org'

ruby '3.1.2'

# Rails and Web Server
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.2'

# JSON API Building
# gem 'jbuilder'

# Redis Support
# gem 'redis', '>= 4.0.1'
# gem 'kredis'

# Password Security
# gem 'bcrypt', '~> 3.1.7'

# Time Zone Data for Windows
platforms :mingw, :x64_mingw, :mswin do
  gem 'tzinfo-data'
  gem 'wdm', '>= 0.1.0'
end

# Boot Time Optimization
gem 'bootsnap', require: false

# CORS Middleware
# gem 'rack-cors'

# Development and Test Group
group :development, :test do
  # Debugging Tools
  # gem 'debug', platforms: %i[mri windows]

  # Test Frameworks
  gem 'activerecord-nulldb-adapter'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner-mongoid'
  gem 'minitest'
  gem 'minitest-rails'
  gem 'rack-test'
end

# Development Group
group :development do
  # Speed Up Commands
  # gem 'spring'

  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
  gem 'rubocop', require: false

  # Linters
  gem 'rubocop-minitest'
  gem 'rubocop-rails'
end

# Other Gems
gem 'actioncable'
gem 'bunny'                 # RabbitMQ client
gem 'devise'                # Authentication solution
gem 'devise-api'           # API support for Devise
gem 'dotenv-rails'         # Environment variables from .env
gem 'httparty'             # Makes HTTP requests easy
gem 'mongoid'              # MongoDB ODM
gem 'nokogiri'             # HTML and XML parsing
gem 'rack-cors', require: 'rack/cors' # CORS handling
gem 'sidekiq' # Background job processing
gem 'sidekiq-scheduler' # Scheduling recurring jobs
