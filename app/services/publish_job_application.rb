# app/services/publish_job_application.rb

require 'bunny'
require 'json'

class PublishJobApplication
  def self.publish(job_id, user_id)
    message = create_test_message(job_id, user_id)

    amqp_url = ENV['CLOUDAMQP_URL'] || 'amqp://guest:guest@localhost:5672/'
    conn = Bunny.new(amqp_url)
    conn.start

    channel = conn.create_channel
    queue = channel.queue('job_applications')

    channel.default_exchange.publish(message, routing_key: queue.name)
    puts "Published message: #{message}"
  ensure
    conn.close if conn
  end

  def self.create_test_message(job_id, user_id)
    {
      job_id: job_id,
      user_id: user_id
    }.to_json
  end
end