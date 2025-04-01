require 'bunny'

class JobProducer
  def self.publish(queue_name, message)
    amqp_url = ENV['CLOUDAMQP_URL'] || 'amqp://guest:guest@localhost:5672/'

    connection = Bunny.new(amqp_url)
    connection.start

    channel = connection.create_channel
    queue = channel.queue(queue_name)

    queue.publish(message)
    puts "Sent #{message}"

    connection.close
  end
end

