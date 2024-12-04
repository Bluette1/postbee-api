# app/services/base_scraper.rb
require 'nokogiri'
require 'httparty'
require 'logger'

class BaseScraper
  def initialize(urls)
    @urls = urls
    @logger = Logger.new($stdout) # Or use a file: Logger.new('log/scraper.log')
    @logger.level = Logger::DEBUG
  end

  def scrape
    @urls.each do |url|
      response = HTTParty.get(url)
      if response.success?
        document = Nokogiri::HTML(response.body)
        parse(document)
      else
        @logger.debug "Failed to fetch #{url}"
      end
    end
  end

  # Define a method to be overridden in subclasses
  def parse(document)
    raise NotImplementedError, 'Subclasses must implement the parse method'
  end
end
