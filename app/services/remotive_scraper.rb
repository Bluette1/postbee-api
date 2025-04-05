# app/services/remote_woman_scraper.rb
class RemotiveScraper < BaseScraper
  def parse(document)
    # Each job listing appears to be a block of content with job details
    document.css('div#initial_job_list ul li div.job-tile').each do |job_element|
      job = {}

      # Extract job title
      title_element = job_element.css('div.job-tile-title span')
      job[:title] = title_element[0].text.strip if title_element && title_element[0] && title_element[0].any?

      @logger.info "Extracted job title #{job[:title]}"

      # Extract company name
      job[:company_title] = title_element[2].text.strip if title_element && title_element[2] && title_element[2].any?

      @logger.info "Extracted company title: #{job[:company_title]} "

      # Extract job link
      link_element = job_element.css('div.job-tile-title a').first
      if link_element
        href = link_element['href']
        job[:link] = href.start_with?('/') ? "https://remotive.com#{href}" : href
      end

      @logger.info "Extracted job link:  #{job[:link]}"

      # Extract location
      location_element = job_element.css('div span.job-tile-location')
      if location_element.any?
        job[:location] = location_element.text.strip.gsub(/\\n/, '')
                                         .split("\n")
                                         .map(&:strip)
                                         .reject(&:empty?)
                                         .join(' ')
      end

      @logger.info "Extracted job location:  #{job[:location]}"

      # Extract job type/time
      job_type_element = job_element.css('div span.job-tile-salary')
      job[:time] = job_type_element.text.strip if job_type_element.any?

      @logger.info "Extracted job time:  #{job[:time]}"

      # Extract date posted
      date_element = job_element.css('div span.job-tile-apply-hide')
      if date_element.any?
        date_text = date_element.text.strip
        # Extract the actual date from text like "Posted 1 day ago"
        job[:date] = if date_text.match(/Posted (.*?)$/)
                       ::Regexp.last_match(1).strip
                     else
                       date_text
                     end
      end

      @logger.info "Extracted job date:  #{job[:date]}"

      # Extract company logo if present
      logo_element = job_element.css('div.tw-flex-shrink-0 img.tw-bg-white.tw-rounded-full')
      @logger.info "Extracted logo element: #{logo_element}"

      if logo_element.any?
        # First try to get the src attribute
        job[:logo] = logo_element.first['src']
        job[:logo] = logo_element.first['data-lazyload'] if job[:logo].nil?
        @logger.info "Extracted company logo: #{job[:logo]}"
      else
        @logger.warn "Company logo not found for job: #{job[:title]}"
      end

      # Required fields validation
      required_keys = %i[title company_title link]
      if required_keys.all? { |key| job[key].to_s.strip.present? }
        handle_job_post(job)
      elsif job[:title].present? && job[:link].present? && job[:company_title].blank?
        # If missing company_title but have title and link, try to extract company from context
        possible_company = extract_company_from_context(job_element, job[:title])
        if possible_company.present?
          job[:company_title] = possible_company
          handle_job_post(job)
        else
          @logger.warn "Company title missing and couldn't be extracted: #{job.inspect}"
        end
      # Try to extract company from the URL or surrounding context
      else
        @logger.warn "One or more required fields are missing or empty: #{job.inspect}"
      end
    end
  end
end

  private

def extract_company_from_context(job_element, job_title)
  # Try different approaches to find company name

  # 1. Look for preceding elements that might contain company name
  prev_element = job_element.previous_element
  return prev_element.text.strip if prev_element && !prev_element.text.strip.empty? && prev_element.text.length < 50

  # 2. Try to extract from parent elements
  parent_text = job_element.parent.text.strip
  if parent_text.include?(' at ') && parent_text.include?(job_title)
    company_match = parent_text.match(/#{Regexp.escape(job_title)}.*?at\s+([^\s]+)/)
    return company_match[1] if company_match
  end

  # 3. Look for specific patterns in the job element itself
  full_text = job_element.text
  company_match = full_text.match(/at\s+([A-Z][A-Za-z0-9\s&]+?)(?:\s+in|\s+\(|\s+-|\n|$)/)
  return company_match[1].strip if company_match

  # If all attempts fail, return nil
  nil
end

def handle_job_post(job)
  job_post = JobPost.find_by(title: job[:title], link: job[:link])

  if job_post
    @logger.warn "Existing record for #{job}"

    # Update the date if the job already exists
    job_post.update(date: job[:date])
    @logger.info "Updated date for #{job_post}"
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
