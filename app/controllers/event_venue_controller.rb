class EventVenueController < ApplicationController
  before_action :set_event
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  # load_and_authorize_resource

  # GET /bands
  def index
  end

  # GET /bands/new
  def new
    @event_band = @event.event_bands.new
  end

  def unset
    @event.update_attribute(:venue_id, nil)
    redirect_to action: :index
  end

  def set
    if params[:venue_id]
      @event.update_attribute(:venue_id, params[:venue_id])
      redirect_to action: :index
    end
  end

  def set_city
    if params[:venue]
      @venue = Venue.new(location_params)

      begin
        venue = Venue.find_or_create_tba(location_params['latitude'], location_params['longitude'])
      rescue => e
        redirect_to set_city_event_event_venue_index_path(@event), alert: 'Something went wrong. Please try again'; return false
      end

      if @event.update_attribute(:venue_id, venue.id)
        redirect_to action: :index
      end
    else
      @venue = Venue.new
    end
  end

  def add
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:event_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_band_params
      params.require(:band).permit(
        :band_id, :event_id
      )
    end

    def location_params
      params.require(:venue).permit(
        :latitude, :longitude
      )
    end
end
