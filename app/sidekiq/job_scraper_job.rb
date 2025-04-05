class JobScraperJob
  include Sidekiq::Job

  def perform(*_args)
    # Define URLs for each scraper
    remotive_urls = ['https://remotive.com/remote-jobs/software-dev']
    weworkremotely_urls = [
      'https://weworkremotely.com/categories/remote-full-stack-programming-jobs#job-listings',
      'https://weworkremotely.com/categories/remote-front-end-programming-jobs#job-listings',
      'https://weworkremotely.com/categories/remote-back-end-programming-jobs#job-listings'
    ]
    remote_co_urls = [
      'https://remote.co/remote-jobs/developer'

    ]
    remote_ok_urls = ['https://remoteok.com/remote-dev-jobs']

    remote_woman_urls = ['https://remotewoman.com/remote-developer-jobs']

    

    # Create and run scrapers
    scraper_types = {
      remotive: remotive_urls,
      # weworkremotely: weworkremotely_urls,
      # remote_co: remote_co_urls,
      # remote_ok: remote_ok_urls,
      # remote_woman: remote_woman_urls
    }

    scraper_types.each do |type, urls|
      scraper = ScraperFactory.create_scraper(type, urls)
      scraper.scrape
    end
  end
end
