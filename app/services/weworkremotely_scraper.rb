# app/services/weworkremotely_scraper.rb
class WeworkremotelyScraper < BaseScraper
  def parse(document)
    document.css('section.jobs article ul li:not(:first-child)').each do |li|
      job = {}
      base_url = 'https://weworkremotely.com'
      links = li.css('a')

      if links.length > 1
        href = links[1]['href']
        job[:link] = href.start_with?('/') ? "#{base_url}#{href}" : href
      end
      job[:company_title] = li.css('span:first-child.company').text.strip
      job[:title] = li.css('span.title').text.strip
      job[:time] = li.css('span:not(:first-child).company').map(&:text).map(&:strip).first
      job[:location] = li.css('span.region.company').text.strip
      job[:date] = li.css('span.listing-date__date').text.strip
      job[:featured] = li.css('span.featured').text.strip

      logo_section = li.css('div.tooltip--flag-logo a')
      job[:company_link] = "#{base_url}#{logo_section.first['href']}" if logo_section.any?

      job[:logo] = extract_logo_from_style(logo_section)

      # Required fields validation
      required_keys = %i[title company_title link]
      if required_keys.all? { |key| job[key].to_s.strip.present? }
        handle_job_post(job)
      else
        @logger.warn "One or more required fields are missing or empty: #{job.inspect}"
      end
    end
  end

  private

  def extract_logo_from_style(logo_section)
    logo_section.css('div.flag-logo').map do |anchor|
      style_attr = anchor.attribute('style')
      if style_attr
        match = style_attr.value.match(/background-image:\s*url\((['"]?)([^'"]+)\1\)/)
        match[2] if match
      end
    end.compact.first
  end

  def handle_job_post(job)
    job_post = JobPost.find_by(title: job[:title], link: job[:link])

    if job_post
      @logger.warn "Existing record for #{job}"
    else
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
        @logger.error "Failed to save #{job_post.errors.full_messages.join(', ')}"
      end
    end
  end
end
