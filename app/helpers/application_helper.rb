module ApplicationHelper
  def markdown(body ='')
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    return markdown.render(body).html_safe
  end

  def avatar_url(user, options = {})
    options[:size] ||= 50

    # if user.avatar_url.present?
    #   user.avatar_url
    # else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      url = "http://gravatar.com/avatar/#{gravatar_id}.png?d=mm"

      # Remove size param if size is set to -1
      url = url + "&s=#{options[:size]}" if options[:size] != -1
    # end

    url
  end
end
