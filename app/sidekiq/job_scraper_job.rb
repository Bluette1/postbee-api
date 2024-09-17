class JobScraperJob
  include Sidekiq::Job

  def perform(*_args)
    # Define URLs for each scraper
    weworkremotely_urls = ['https://weworkremotely.com/categories/remote-full-stack-programming-jobs#job-listings']
    remote_co_urls = ['https://remote.co/remote-jobs/developer/']
    remote_ok_urls = ['https://remoteok.com/remote-dev-jobs']

    # Create and run scrapers
    scraper_types = {
      # weworkremotely: weworkremotely_urls,
      remote_co: remote_co_urls,
      # remote_ok: remote_ok_urls
    }

    scraper_types.each do |type, urls|
      scraper = ScraperFactory.create_scraper(type, urls)
      scraper.scrape
    end
  end
end
