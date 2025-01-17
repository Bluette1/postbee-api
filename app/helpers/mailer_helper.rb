module MailerHelper
  def slugify(job_title, company_name)
    text = "#{job_title} #{company_name}"
    text.downcase!
    text.gsub!(/\s+/, '-')
    text.gsub!(/[^\w-]/, '')
    text.gsub!(/-{2,}/, '-')
    text.strip!
    text
  end
end
