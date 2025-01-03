require 'bunny'

class RabbitmqConsumer
  def self.start(queue_name)
    connection = Bunny.new(ENV['RABBITMQ_URL'])
    connection.start

    channel = connection.create_channel
    queue = channel.queue(queue_name)

    puts "Waiting for messages in #{queue_name}. To exit press CTRL+C"

    begin
      queue.subscribe(block: true) do |_delivery_info, _properties, body|
        puts "Received #{body}"
        # Process your message here

        channel.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt => _e
      channel.close
      connection.close
    end
  end
end
