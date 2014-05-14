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
      default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{options[:size]}&d=#{CGI.escape(default_url)}"
    # end
  end
end
