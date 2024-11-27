# spec/factories/job_posts.rb
FactoryBot.define do
  factory :job_post do
    title { 'Ruby Developer' }
    company_title { 'Tech Corp' }
    location { 'Remote' }
    time { 'Full-time' }
    link { 'https://example.com/jobs/1' }
  end
end
