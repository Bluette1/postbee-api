# publish_job_application.rb
# For testing purposes only

require 'bunny'
require 'json'

# Define the message to publish
def create_test_message(job_id, user_id)
  {
    job_id: job_id,
    user_id: user_id
  }.to_json
end

# Main publishing logic
begin
  amqp_url = ENV['CLOUDAMQP_URL'] || 'amqp://guest:guest@localhost:5672/mary'
  conn = Bunny.new(amqp_url)
  conn.start

  channel = conn.create_channel
  queue = channel.queue('job_applications')

  # Create a test message
  test_message = create_test_message(1, 123) # Change IDs as needed

  # Publish the message
  channel.default_exchange.publish(test_message, routing_key: queue.name)
  puts "Published message: #{test_message}"

rescue StandardError => e
  puts "An error occurred: #{e.message}"
ensure
  conn.close if conn
end