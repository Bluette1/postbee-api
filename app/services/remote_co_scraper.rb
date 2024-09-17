# app/services/remote_co_scraper.rb
class RemoteCoScraper < BaseScraper
  def parse(document)
    document.css('a.card').each do |card|
      job = {}
      base_url = 'https://remote.co'
      job[:link] = "#{base_url}#{card['href']}"
      job[:title] = card.css('p span.font-weight-bold.larger').text.strip
      job[:company_title] =
        card.css('p.text-secondary').text.gsub(/&nbsp;|\u00A0/, ' ').split('|').first.strip.gsub(/\s+/, ' ').strip
      job[:date] = card.css('date').text.strip
      job[:logo] = card.css('img.card-img')[1]['src']
       
      badges = card.css('span.badge.badge-success small')
      badges = badges.map { |badge| badge.text.strip }
      job[:badge] = badges

      required_keys = %i[title company_title link]

      if required_keys.all? { |key| job[key].to_s.strip.present? }
        job_post = JobPost.new(
          title: job[:title],
          link: job[:link],
          company_title: job[:company_title],
          company_link: job[:company_link],
          logo: job[:logo],
          date: job[:date],
          badge: job[:badge]
        )
        if job_post.save
          puts "JOB: #{job}"
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
