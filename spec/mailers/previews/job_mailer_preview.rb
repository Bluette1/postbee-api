# spec/mailers/previews/job_mailer_preview.rb
class JobMailerPreview < ActionMailer::Preview
  def new_job_notification
    user = User.first || create(:user)
    job_post = JobPost.first || create(:job_post)
    JobMailer.new_job_notification(user, job_post)
  end
end
