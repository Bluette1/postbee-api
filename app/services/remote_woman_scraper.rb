# app/services/remote_woman_scraper.rb
class RemoteWomanScraper < BaseScraper
  def parse(document)
    # Each job listing appears to be a block of content with job details
    document.css('ul.job_listings li.job_listing').each do |job_element|
      job = {}
      
      # Extract job title
      title_element = job_element.css('h3.job_listing-title')
      job[:title] = title_element.text.strip if title_element.any?
      
      @logger.info "Extracted job title: for #{job[:title]}"

      # Extract company name
      company_element = job_element.css('div.job_listing-company')
      job[:company_title] = company_element.text.strip if company_element.any?
      
      @logger.info "Extracted company title: #{job[:company_title]} "
      
      # Extract job link
      link_element = job_element.css('a.job_listing-clickbox').first
      if link_element
        href = link_element['href']
        job[:link] = href.start_with?('/') ? "https://remotewoman.com#{href}" : href
      end

      @logger.info "Extracted job link:  #{job[:link]}"

      
      # Extract location
      location_element = job_element.css('div.job_listing-location a.google_map_link')
      job[:location] = location_element.text.strip if location_element.any?
      
      @logger.info "Extracted job location:  #{job[:location]}"
      
      
      # Extract job type/time
      job_type_element = job_element.css('li.job_listing-type')
      job[:time] = job_type_element.text.strip if job_type_element.any?
      

      @logger.info "Extracted job time:  #{job[:time]}"

      # Extract date posted
      date_element = job_element.css('li.job_listing-date')
      if date_element.any?
        date_text = date_element.text.strip
        # Extract the actual date from text like "Posted 1 day ago"
        if date_text.match(/Posted (.*?)$/)
          job[:date] = $1.strip
        else
          job[:date] = date_text
        end
      end

      @logger.info "Extracted job date:  #{job[:date]}"
     
      # Extract company logo if present
      logo_element = job_element.css('div.job_listing-logo img.company_logo')
      if logo_element.any?
        # First try to get the src attribute
        job[:logo] = logo_element.first['src']

        # If data-lazy-src is available, use it instead
        if logo_element.first['data-lazy-src']
          job[:logo] = logo_element.first['data-lazy-src']
        end

        @logger.info "Extracted company logo: #{job[:logo]}"
      else
        @logger.warn "Company logo not found for job: #{job[:title]}"
      end

      # Try to extract company link if available
      company_link_element = job_element.css('a.company-link, a[href*="company"]').first
      if company_link_element
        company_href = company_link_element['href']
        job[:company_link] = company_href.start_with?('/') ? "https://remotewoman.com#{company_href}" : company_href
      end
      
      # Required fields validation
      required_keys = %i[title company_title link]
      if required_keys.all? { |key| job[key].to_s.strip.present? }
        handle_job_post(job)
      else
        # If missing company_title but have title and link, try to extract company from context
        if job[:title].present? && job[:link].present? && job[:company_title].blank?
          # Try to extract company from the URL or surrounding context
          possible_company = extract_company_from_context(job_element, job[:title])
          if possible_company.present?
            job[:company_title] = possible_company
            handle_job_post(job)
          else
            @logger.warn "Company title missing and couldn't be extracted: #{job.inspect}"
          end
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
    if prev_element && !prev_element.text.strip.empty? && prev_element.text.length < 50
      return prev_element.text.strip
    end
    
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
end