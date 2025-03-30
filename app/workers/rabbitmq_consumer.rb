require 'bunny'

class RabbitmqConsumer
  def self.start(queue_name)
    # connection = Bunny.new(ENV['RABBITMQ_URL'])
    # Updated connection with proper TLS settings
    connection = Bunny.new(
      host: ENV['RABBITMQ_HOST'],
      port: ENV['RABBITMQ_PORT'].to_i,
      vhost: ENV['RABBITMQ_VHOST'],
      user: ENV['RABBITMQ_USERNAME'],
      password: ENV['RABBITMQ_PASSWORD'],
      ssl: false,
      verify_peer: false,
      fail_if_no_peer_cert: false
      # If client certificates are required, uncomment and set these:
      # tls_cert: ENV['RABBITMQ_CLIENT_CERT'],
      # tls_key: ENV['RABBITMQ_CLIENT_KEY'],
      # tls_ca_certificates: [ENV['RABBITMQ_CA_CERT']]
    )
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
