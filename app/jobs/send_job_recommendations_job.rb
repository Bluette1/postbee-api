class SendJobRecommendationsJob < ApplicationJob
  queue_as :default

  def perform(user_id = nil)
    if user_id
      user = User.find(user_id)
      available_jobs = JobPost.all.limit(5)
      JobRecommendationMailer.send_job_recommendations(user, available_jobs).deliver_now
    else
      users = User.all

      users.each do |user|
        available_jobs = JobPost.all.limit(5)
        JobRecommendationMailer.send_job_recommendations(user, available_jobs).deliver_now
      end
    end
  end
end
