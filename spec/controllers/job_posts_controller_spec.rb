# spec/controllers/job_posts_controller_spec.rb
RSpec.describe JobPostsController, type: :controller do
  describe 'POST #create' do
    let(:valid_attributes) do
      {
        title: 'Ruby Developer',
        company_title: 'Tech Corp',
        location: 'Remote',
        time: 'Full-time',
        link: 'https://example.com/jobs/1'
      }
    end

    let!(:users) { create_list(:user, 3) }

    before do
      allow(RabbitmqProducer).to receive(:publish)
    end

    context 'with valid params' do
      it 'creates a new job post and sends emails to all users' do
        expect do
          post :create, params: { job_post: valid_attributes }
        end.to change(JobPost, :count).by(1)
                                      .and change(ActionMailer::Base.deliveries, :count).by(users.count)
      end

      it 'publishes message to RabbitMQ' do
        post :create, params: { job_post: valid_attributes }
        expect(RabbitmqProducer).to have_received(:publish)
          .with('queue', 'Hello, a new job has been posted!')
      end

      it 'returns created status' do
        post :create, params: { job_post: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { title: nil } }

      it 'does not create a job post or send emails' do
        expect do
          post :create, params: { job_post: invalid_attributes }
        end.to not_change(JobPost, :count)
          .and not_change(ActionMailer::Base.deliveries, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: { job_post: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
