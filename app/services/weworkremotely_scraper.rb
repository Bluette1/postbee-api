# app/services/weworkremotely_scraper.rb
class WeworkremotelyScraper < BaseScraper
  def parse(document)
    document.css('section.jobs article ul li:not(:first-child)').each do |li|
      job = {}
      links = li.css('a')
      base_url = 'https://weworkremotely.com'
      job[:link] = "#{base_url}#{links[1]['href']}" if links.length > 1

      company_title = li.css('span:first-child.company').text
      job[:company_title] = company_title if company_title != ''
      job[:title] = li.css('span.title').text
      time = li.css('span:not(:first-child).company')
      time = time.map { |time_node| time_node.text.strip }
      job[:time] = time[0]

      job[:location] = li.css('span.region.company').text
      job[:date] = li.css('span.date time').text
      job[:featured] = li.css('span.featured').text

      logo_section = li.css('div.tooltip--flag-logo a')
      company_href_urls = logo_section.map { |link| link['href'] }

      job[:company_link] = "#{base_url}#{company_href_urls[0]}"

      background_image_urls = logo_section.css('div.flag-logo').map do |anchor|
        style_attr = anchor.attribute('style')
        if style_attr
          style_attr.value.match(/background-image:\s*url\((['"]?)([^'"]+)\1\)/)
          ::Regexp.last_match(2) # The matched background image URL
        end
      end

      job[:logo] = background_image_urls[0]

      required_keys = %i[title company_title link]

      if required_keys.all? { |key| job[key].to_s.strip.present? }
        # All required fields are present and non-empty
        job_post = JobPost.new(
          title: job[:title],
          link: job[:link],
          company_title: job[:company_title],
          company_link: job[:company_link],
          time: job[:time],
          location: job[:location],
          date: job[:date],
          featured: job[:featured],
          logo: job[:logo]
        )
        if job_post.save
          @logger.info "Saved #{job_post}"
        else
          @logger.error "Failed to save #{job_post.errors.full_messages}"
        end
      else
        @logger.warn "One or more required fields are missing or empty #{job}"
      end
    end
  end
end
