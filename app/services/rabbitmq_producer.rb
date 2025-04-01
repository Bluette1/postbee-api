require 'bunny'

class RabbitmqProducer
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

# require 'bunny'

# class RabbitmqProducer
#   def self.publish(queue_name, message)
#     # Updated connection with proper TLS settings
#     connection = Bunny.new(
#       host: ENV['RABBITMQ_HOST'],
#       port: ENV['RABBITMQ_PORT'].to_i,
#       vhost: ENV['RABBITMQ_VHOST'],
#       user: ENV['RABBITMQ_USERNAME'],
#       password: ENV['RABBITMQ_PASSWORD'],
#       ssl: false,
#       verify_peer: false,
#       fail_if_no_peer_cert: false,
#       # If client certificates are required, uncomment and set these:
#       # tls_cert: ENV['RABBITMQ_CLIENT_CERT'],
#       # tls_key: ENV['RABBITMQ_CLIENT_KEY'],
#       # tls_ca_certificates: [ENV['RABBITMQ_CA_CERT']]
#     )
#     connection.start

#     channel = connection.create_channel
#     queue = channel.queue(queue_name)

#     queue.publish(message)
#     puts "Sent #{message}"

#     connection.close
#   end
# end
