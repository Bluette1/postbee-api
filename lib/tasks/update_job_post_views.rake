namespace :job_posts do
  desc 'Reset view counts and last viewed for all job posts'
  task reset_views: :environment do
    JobPost.all.each do |job_post|
      job_post.update(view_count: 0, last_viewed: nil)
    end
    puts 'Updated view counts and last viewed for all job posts.'
  end
end
