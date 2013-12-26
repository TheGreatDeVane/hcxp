module EventsHelper
  def event_date_to_words(date, format = '%d.%m.%Y')
    # calculate distance in days
    days = (Time.zone.now - date).to_i / 1.day

    # Custom strings
    return 'Yesterday' if days == 1
    return 'Today'     if days == 0
    return 'Tomorrow'  if days == -1

    # Default format
    return date.strftime(format)
  end

  def excerpt(event)
    html_body = markdown(event.description)
    noko      = Nokogiri::HTML(html_body)
    return noko.css('p').first.try(:content)
  end
end
