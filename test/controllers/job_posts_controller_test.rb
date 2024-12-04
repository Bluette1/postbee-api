require 'test_helper'

class JobPostsControllerTest < Minitest::Test
  include Rack::Test::Methods
  include ActiveJob::TestHelper

  def setup
    @app = Rails.application
    @job_post = JobPost.create!(
      title: 'Ruby Developer',
      company_title: 'Tech Corp',
      location: 'Remote',
      time: 'Full-time',
      link: 'https://example.com/jobs/1'
    )
  end

  def test_should_create_job_post
    initial_count = JobPost.count

    post '/job_posts', job_post: {
      title: 'Rails Developer',
      company_title: 'Tech Corp',
      location: 'Remote',
      time: 'Full-time',
      link: 'https://example.com/jobs/2'
      # }
    }, as: :json

    assert_enqueued_jobs 1

    assert last_response.status == 201 # Check response status
    assert_equal initial_count + 1, JobPost.count # Verify the count has increased
    assert_equal 'Rails Developer', JSON.parse(last_response.body)['title']
  end

  private

  attr_reader :app
end
