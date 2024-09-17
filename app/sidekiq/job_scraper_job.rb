class JobScraperJob
  include Sidekiq::Job

  def perform(*_args)
    urls = [
      'https://weworkremotely.com/categories/remote-full-stack-programming-jobs#job-listings'
    ]
    scraper = Scraper.new(urls)
    scraper.scrape
  end
end
