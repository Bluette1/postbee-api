class JobMailer < ApplicationMailer
  default from: 'no-reply@postbee.com'

  def new_job_notification(user, job)
    @user = user
    @job = job
    mail(to: @user.email, subject: "New Job Posting Alert: #{@job.title}")
  end
end
