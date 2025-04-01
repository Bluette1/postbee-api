# app/workers/job_consumer.rb
require 'bunny'

class JobConsumer
  def self.start(queue_name)
    @connection = Bunny.new(ENV['CLOUDAMQP_URL'] || 'amqp://guest:guest@localhost:5672/mary')
    
    begin
      @connection.start
      channel = @connection.create_channel
      queue = channel.queue(queue_name)

      puts "Waiting for messages in #{queue_name}. To exit press CTRL+C"

      # Set up a consumer that handles messages more explicitly
      consumer = queue.subscribe(manual_ack: true) do |delivery_info, _properties, body|
        begin
          puts "Received #{body}"
          channel.ack(delivery_info.delivery_tag)
        rescue => e
          puts "Error processing message: #{e.message}"
          channel.reject(delivery_info.delivery_tag, true) # requeue the message
        end
      end

      # This keeps the main thread alive
      loop do
        sleep 1
      end
    rescue Interrupt => _e
      puts "Shutting down gracefully..."
    rescue => e
      puts "Error: #{e.message}"
      puts "Retrying in 5 seconds..."
      sleep 5
      retry
    ensure
      @connection.close if @connection && @connection.connected?
      puts "Connection closed."
    end
  end
end