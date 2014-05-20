class Api::V1::SearchController < Api::V1Controller
  before_action :authenticate_user!

  respond_to :json

  def venues
    @venues = Venue.search(params[:q]).limit(10)
  end

end