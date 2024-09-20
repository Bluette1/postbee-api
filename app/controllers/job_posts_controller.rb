# class JobPostsController < ApplicationController
  class JobPostsController < ApplicationController
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
  
    # POST /job_posts
    def create
      @job_post = JobPost.new(job_post_params)
      if @job_post.save
        render json: @job_post, status: :created
      else
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
      params.require(:job_post).permit(:title, :company, :description, :link)
    end
  end
  
# end
