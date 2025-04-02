# app/services/base_scraper.rb
require 'nokogiri'
require 'httparty'
require 'logger'

class BaseScraper
  MAX_RETRIES = 3
  RETRY_DELAY = 2 # seconds

  def initialize(urls)
    @urls = urls
    @logger = Logger.new($stdout) # Or use a file: Logger.new('log/scraper.log')
    @logger.level = Logger::DEBUG
  end

  def scrape
    @urls.each do |url|
      retries = 0
      begin
        response = HTTParty.get(url)

        if response.success?
          document = Nokogiri::HTML(response.body)
          parse(document)
        else
          @logger.debug "Failed to fetch #{url} with status: #{response.code} - #{response.message}"
        end
      rescue Errno::ECONNRESET => e
        retries += 1
        if retries <= MAX_RETRIES
          # rubocop:disable Layout/LineLength
          @logger.warn "Connection reset by peer while fetching #{url}. Retrying in #{RETRY_DELAY} seconds... (Attempt ##{retries})"
          sleep(RETRY_DELAY)
          retry
          # rubocop:enable Layout/LineLength
        else
          @logger.error "Failed to fetch #{url} after #{MAX_RETRIES} retries: #{e.message}"
        end
      rescue StandardError => e
        @logger.error "An error occurred while fetching #{url}: #{e.message}"
      end
    end
  end

  # Define a method to be overridden in subclasses
  def parse(document)
    raise NotImplementedError, 'Subclasses must implement the parse method'
  end
end
