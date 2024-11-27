# spec/mailers/job_mailer_spec.rb
require 'rails_helper'

RSpec.describe JobMailer, type: :mailer do
  describe '#new_job_notification' do
    let(:user) { create(:user, email: 'test@example.com') }
    let(:job_post) do
      create(:job_post,
             title: 'Ruby Developer',
             company_title: 'Tech Corp',
             location: 'Remote',
             time: 'Full-time',
             link: 'https://example.com/jobs/1')
    end
    let(:mail) { described_class.new_job_notification(user, job_post) }

    it 'renders the headers' do
      expect(mail.subject).to eq("New Job Posting Alert: #{job_post.title}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@postbee.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('New Job Posting Alert!')
      expect(mail.body.encoded).to include(job_post.title)
      expect(mail.body.encoded).to include(job_post.company_title)
      expect(mail.body.encoded).to include(job_post.location)
      expect(mail.body.encoded).to include(job_post.time)
      expect(mail.body.encoded).to include(job_post.link)
    end
  end
end
