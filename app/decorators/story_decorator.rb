class StoryDecorator < Draper::Decorator
  delegate_all

  def domain
    url = "http://#{object.url}" if URI.parse(object.url).scheme.nil?
    host = URI.parse(object.url).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

end