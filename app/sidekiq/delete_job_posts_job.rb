class DeleteJobPostsJob
  include Sidekiq::Job

  def perform(*_args)
    JobPost.delete_all
  end
end