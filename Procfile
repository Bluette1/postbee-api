web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
worker: bundle exec sidekiq
# worker: rails runner app/workers/run_job_application_consumer.rb
# worker: rails runner app/workers/run_job_consumer.rb
