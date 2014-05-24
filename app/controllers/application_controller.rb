class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def style_guide; end

  private

    def set_locale
      if cookies[:locale]
        I18n.locale = cookies[:locale]
      end

      if params[:locale]
        cookies[:locale] = params[:locale] || I18n.default_locale
        I18n.locale      = cookies[:locale]
      end
    end
end
