# app/workers/start_job_application_consumer.rb

require_relative 'job_application_consumer' # Load the consumer

consumer = JobApplicationConsumer.new
consumer.start
