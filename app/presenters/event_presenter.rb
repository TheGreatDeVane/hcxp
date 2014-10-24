class EventPresenter
  include ActionView::Helpers::TagHelper

  def initialize(event)
    @event = event
  end

  def links
    links = []

    %w(social_link_lfm social_link_fb).each do |col|
      link = @event.send(col)
      links << {
        url:       link,
        formatted: formatted_link(link).html_safe
      } if link.present?
    end

    links
  end

  private

  def formatted_link(link)
    l = link
      .gsub(/^(\S+:\/\/www.)/, '')
      .gsub(/^(\S+:\/\/)/, '')

    highlight_link_providers(l)
  end

  def highlight_link_providers(link)
    %w(facebook lastfm last.fm).each do |provider|
      link = link.gsub(provider, content_tag(:mark, provider))
    end

    link
  end
end