# app/models/job_post.rb
class JobPost
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :company_title, type: String
  field :company_link, type: String
  field :time, type: String
  field :location, type: String
  field :date, type: String
  field :featured, type: String
  field :link, type: String
  field :logo, type: String
  field :badge, type: Array

  validates :title, :company_title, :link, presence: true
end
