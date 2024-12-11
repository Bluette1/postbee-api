Rails.application.routes.draw do
  # Health check endpoint
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Resources for job posts
  resources :job_posts

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
