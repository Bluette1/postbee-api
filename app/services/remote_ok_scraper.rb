# app/services/remote_ok_scraper.rb
class RemoteOkScraper < BaseScraper
  def parse(document)
    document.css('tr.job').each do |card|
      job = {}
      base_url = 'https://remoteok.com'
      link = card.css('a.preventLink').attribute('href')

      job[:link] = "#{base_url}#{link}"
      job[:title] = card.css('a.preventLink h2').text.strip
      company_title = card.css('span.companyLink h3').text.strip

      job[:company_title] = company_title

      job[:company_link] = "#{base_url}/#{company_title.downcase.split(' ').join('-')}"

      job[:date] = card.css('time').text.strip
      logo = card.css('img.logo')

      job[:logo] = logo.attribute('data-src').to_s

      tags = card.css('td.tags a.action-add-tag h3')

      tags = tags.map { |tag| tag.text.strip }
      job[:tags] = tags

      required_keys = %i[title company_title link]

      if required_keys.all? { |key| job[key].to_s.strip.present? }
        job_post = JobPost.new(
          title: job[:title],
          link: job[:link],
          company_title: job[:company_title],
          company_link: job[:company_link],
          logo: job[:logo],
          date: job[:date],
          tags: job[:tags]
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
