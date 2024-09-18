# app/services/remote_co_scraper.rb
class RemoteCoScraper < BaseScraper
  def parse(document)
    document.css('a.card').each do |card|
      job = {}
      base_url = 'https://remote.co'

      job[:link] = "#{base_url}#{card['href']}"
      job[:title] = card.css('p span.font-weight-bold.larger').text.strip

      job[:company_title] = card.css('p.text-secondary').text
                                .gsub(/&nbsp;|\u00A0/, ' ')
                                .split('|')
                                .first
                                .strip
                                .gsub(/\s+/, ' ')

      job[:date] = card.css('date').text.strip

      logo_elements = card.css('img.card-img')
      job[:logo] = logo_elements[1] ? logo_elements[1]['src'] : nil

      badges = card.css('span.badge.badge-success small')
      job[:badges] = badges.map(&:text).map(&:strip)

      required_keys = %i[title company_title link]

      if required_keys.all? { |key| job[key].to_s.strip.present? }
        job_post = JobPost.find_by(title: job[:title], link: job[:link])

        if job_post
          @logger.warn "Existing record for #{job}"
        else
          job_post = JobPost.new(
            title: job[:title],
            link: job[:link],
            company_title: job[:company_title],
            logo: job[:logo],
            date: job[:date],
            badges: job[:badges]
          )

          if job_post.save
            @logger.info "Saved #{job_post}"
          else
            @logger.error "Failed to save #{job_post.errors.full_messages}"
          end
        end
      else
        @logger.warn "One or more required fields are missing or empty: #{job}"
      end
    end
  end
end
