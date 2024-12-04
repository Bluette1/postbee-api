# features/step_definitions/api_steps.rb

require 'rack/test'
require 'json'
require 'minitest/autorun'

module ApiHelpers
  include Rack::Test::Methods
  include Minitest::Assertions

  def app
    Rack::Builder.new do
      use Rack::MethodOverride
      run Rails.application
    end
  end
end

World(ApiHelpers)

Given('I send a POST request to {string} with the following data:') do |path, json_data|
  post path, json_data, { 'CONTENT_TYPE' => 'application/json' }
end

Then('the response status should be {int}') do |status|
  assert_equal status.to_i, last_response.status
end

Then('the response body should contain {string}') do |content|
  assert_includes last_response.body, content
end
