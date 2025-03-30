# require 'bunny'
# require 'json'

# class JobApplicationConsumer
#   def initialize
#     @conn = Bunny.new
#     @conn.start
#     @channel = @conn.create_channel
#     @queue = @channel.queue('job_applications')
#   end

#   def start
#     @queue.subscribe(block: true) do |_delivery_info, _properties, body|
#       message = JSON.parse(body)
#       process_application(message)
#     end
#   end

#   def process_application(message)
#     job_id = message['job_id']
#     user_id = message['user_id']
#     send_email_recommendations(user_id, job_id)
#   end

#   def send_email_recommendations(user_id, job_id)
#     user = User.find(user_id) # Find user by ID
#     job = Job.find(job_id) # Find the applied job

#     # Fetch job recommendations based on the same company and job role type
#     job_recommendations = Job.where(company_id: job.company_id, role_type: job.role_type).limit(5)

#     # Send email with job recommendations
#     JobRecommendationMailer.send_job_recommendations(user, job_recommendations).deliver_now
#   end
# end

require 'bunny'
require 'json'

class JobApplicationConsumer
  def initialize
    # Updated connection with proper TLS settings
    @conn = Bunny.new(
      # Use environment variables for sensitive information
      host: ENV['RABBITMQ_HOST'],
      port: ENV['RABBITMQ_PORT'].to_i,
      vhost: ENV['RABBITMQ_VHOST'],
      user: ENV['RABBITMQ_USERNAME'],
      password: ENV['RABBITMQ_PASSWORD'],
      ssl: false,
      verify_peer: true,
      fail_if_no_peer_cert: false
      # If client certificates are required, uncomment and set these:
      # tls_cert: ENV['RABBITMQ_CLIENT_CERT'],
      # tls_key: ENV['RABBITMQ_CLIENT_KEY'],
      # tls_ca_certificates: [ENV['RABBITMQ_CA_CERT']]
    )
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
    user = User.find(user_id) # Find user by ID
    job = Job.find(job_id) # Find the applied job

    # Fetch job recommendations based on the same company and job role type
    job_recommendations = Job.where(company_id: job.company_id, role_type: job.role_type).limit(5)

    # Send email with job recommendations
    JobRecommendationMailer.send_job_recommendations(user, job_recommendations).deliver_now
  end
end
