# app/jobs/send_job_recommendations_job.rb
class SendJobRecommendationsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    
    # Fetch available job roles (customize the query as needed)
    available_jobs = Job.all.limit(10)  # Modify as required

    # Send the email with available job recommendations
    JobRecommendationMailer.send_job_recommendations(user, available_jobs).deliver_now
  end
end