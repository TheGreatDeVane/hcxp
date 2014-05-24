module EventsHelper
  def event_date_to_words(date, format = '%d.%m.%Y')
    # calculate distance in days
    days = (Time.zone.now - date).to_i / 1.day

    # Custom strings
    return t('time.yesterday') if days == 1
    return t('time.today')     if days == 0
    return t('time.tomorrow')  if days == -1

    # Default format
    return l(date, format: format)
  end

  def excerpt(event)
    html_body = markdown(event.description)
    noko      = Nokogiri::HTML(html_body)
    return noko.css('p').first.try(:content)
  end
end
