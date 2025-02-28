Rails.application.routes.draw do
  # Health check endpoint
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :job_posts do
    post 'increment_view_count', on: :member
  end

  post '/validate_token', to: 'tokens#validate'

  # Devise routes for users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }, skip: [:sessions]

  devise_scope :user do
    post 'users/sign_in', to: 'users/sessions#create'
    delete 'users/sign_out', to: 'users/sessions#destroy'
    post 'users/refresh', to: 'users/sessions#refresh'
  end
end
