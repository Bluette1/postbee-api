# app/jobs/send_job_notification_job.rb

class SendJobNotificationJob < ApplicationJob
  queue_as :default

  def perform(job_post_id)
    job_post = JobPost.find(job_post_id)
    User.all.cursor.each do |user|
      JobMailer.new_job_notification(user, job_post).deliver_later
    end
  end
end
