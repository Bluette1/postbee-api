require 'bunny'

class RabbitmqProducer
  def self.publish(queue_name, message)
    connection = Bunny.new(ENV['RABBITMQ_URL'])
    connection.start

    channel = connection.create_channel
    queue = channel.queue(queue_name)

    queue.publish(message)
    puts "Sent #{message}"

    connection.close
  end
end
