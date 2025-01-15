require 'bunny'
require 'json'

class JobApplicationConsumer
  def initialize
    @conn = Bunny.new
    @conn.start
    @channel = @conn.create_channel
    @queue = @channel.queue('job_applications')
  end

  def start
    @queue.subscribe(block: true) do |_delivery_info, _properties, body|
      message = JSON.parse(body)
      process_application(message)
    end
  end

  def process_application(message)
    job_id = message['job_id']
    user_id = message['user_id']
    send_email_recommendations(user_id, job_id)
  end

  def send_email_recommendations(user_id, job_id)
    # Implement email sending logic here
  end
end
