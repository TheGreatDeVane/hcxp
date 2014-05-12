class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :get_cities

  # Fetch cities (based on venues) to populate
  # sidebar's 'Cities' list.
  def get_cities
    @cities = Venue.select('DISTINCT(city), country_code')
  end

  def style_guide; end
end
