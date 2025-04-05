# app/services/scraper_factory.rb
class ScraperFactory
  def self.create_scraper(type, urls)
    case type
    when :weworkremotely
      WeworkremotelyScraper.new(urls)
    when :remote_co
      RemoteCoScraper.new(urls)
    when :remote_ok
      RemoteOkScraper.new(urls)
    when :remote_woman
      RemoteWomanScraper.new(urls)
    when :remotive
      RemotiveScraper.new(urls)
    else
      raise "Unknown scraper type: #{type}"
    end
  end
end
