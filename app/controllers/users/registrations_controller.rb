module Users
  class RegistrationsController < Devise::RegistrationsController
    after_action :schedule_job_recommendation, only: [:create]

    respond_to :json

    def create
      build_resource(sign_up_params)

      if resource.save
        yield resource if block_given?
        render json: resource, status: :created
      else
        Rails.logger.error "User creation failed: #{resource.errors.full_messages.join(', ')}"
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def schedule_job_recommendation
      SendJobRecommendationsJob.set(wait_until: 1.day.from_now).perform_later(resource.id)
    end
  end
end
