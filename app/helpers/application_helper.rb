module ApplicationHelper
  def markdown(body = '')
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    return markdown.render(body).html_safe
  end

  def avatar_url(user, options = {})
    options[:size] ||= 50

    # if user.avatar_url.present?
    #   user.avatar_url
    # else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{options[:size]}&d=mm"
    # end
  end

  def page_title(title = nil)
    final_title = ''

    # If title is present
    final_title = "#{title} / " if title.present?

    # Append site_name to page title
    final_title = final_title + Settings.general.site_name

    # If there is no custom title set, append
    # site subtitle to site name
    (final_title = final_title + ' - ' + Settings.general.subtitle) unless title.present?

    final_title
  end

  def flash_class(level)
    case level
      when 'notice'  then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error'   then "alert alert-danger"
      when 'alert'   then "alert alert-warning"
    end
  end
end
