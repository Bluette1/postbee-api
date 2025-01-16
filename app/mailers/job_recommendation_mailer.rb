class JobRecommendationMailer < ApplicationMailer
  default from: 'no-reply@postbee.com'

  def send_job_recommendations(user, job_recommendations)
    @user = user
    @job_recommendations = job_recommendations
    mail(to: @user.email, subject: 'Job Recommendations for You')
  end
end
