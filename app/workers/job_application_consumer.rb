require 'bunny'
require 'json'

class JobApplicationConsumer
  def initialize
    amqp_url = ENV['CLOUDAMQP_URL']
    @conn = Bunny.new(amqp_url)
    @conn.start
    @channel = @conn.create_channel
    @queue = @channel.queue('job_applications')
  end

  def start
    @queue.subscribe(block: true) do |_delivery_info, _properties, body|
      puts "Received #{body}"
      message = JSON.parse(body)
      process_application(message)
    end
  end

  def process_application(message)
    job_id = message['job_id']
    user_id = message['user_id']
    puts "Received #{message}"


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
