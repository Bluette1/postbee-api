class JobPostsController < ApplicationController
  require_relative '../services/job_producer' # Corrected require statement
  # GET /job_posts
  def index
    @job_posts = JobPost.all
    render json: @job_posts
  end

  # GET /job_posts/:id
  def show
    @job_post = JobPost.find(params[:id])
    render json: @job_post
  end

  def increment_view_count
    job_post = JobPost.find(params[:id])

    job_post.view_count += 1
    job_post.last_viewed = Time.current
    job_post.save

    render json: {
      view_count: job_post.view_count,
      last_viewed: job_post.last_viewed.iso8601
    }, status: :ok
  end

  # POST /job_posts
  def create
    @job_post = JobPost.new(job_post_params)

    if @job_post.save
      JobProducer.publish('queue', 'Hello, a new job has been posted!')

      SendJobNotificationJob.perform_later(@job_post.id)

      render json: @job_post, status: :created

    else
      Rails.logger.error "Job creation failed: #{@job_post.errors.full_messages.join(', ')}"

      render json: @job_post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /job_posts/:id
  def update
    @job_post = JobPost.find(params[:id])
    if @job_post.update(job_post_params)
      render json: @job_post
    else
      render json: @job_post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job_posts/:id
  def destroy
    @job_post = JobPost.find(params[:id])
    @job_post.destroy
    head :no_content
  end

  private

  def job_post_params
    params.require(:job_post).permit(:title, :company_title, :time, :link, :location, :company_link, :tags, :badges,
                                     :date, :logo, :featured)
  end
end
