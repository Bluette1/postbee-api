# job_application_consumer_script.rb

require_relative 'job_application_consumer' # Adjust the path as necessary

# Create an instance of the JobApplicationConsumer
consumer = JobApplicationConsumer.new

# Start consuming messages
begin
  puts "Starting Job Application Consumer..."
  consumer.start
rescue Interrupt
  puts "Shutting down Job Application Consumer..."
ensure
  consumer.close if consumer.respond_to?(:close)
end