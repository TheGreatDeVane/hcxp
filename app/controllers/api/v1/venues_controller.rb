class Api::V1::VenuesController < Api::V1Controller
  before_action :authenticate_user!
  before_action :set_venue, only: [:show]

  respond_to :json

  def show
  end

  private

    def set_venue
      @venue = Venue.find(params[:id])
    end

end