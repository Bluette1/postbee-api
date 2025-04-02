web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
worker: rails runner app/workers/run_job_consumer.rb
