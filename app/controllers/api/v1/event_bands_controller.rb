class Api::V1::EventBandsController < Api::V1Controller
  before_action :authenticate_user!, only: [:create]
  skip_before_filter :verify_authenticity_token
  before_action :set_event
  before_action :set_event_band, only: [:show]

  respond_to :json

  def index
    @event_bands = @event.event_bands.all
  end

  def show
  end

  def create
    @event_band = @event.event_bands.new(event_band_params)

    if @event_band.save
      render action: 'show', status: :created
    else
      render json: @event_band.errors, status: :unprocessable_entity
    end

  end

  private

    def event_band_params
      params.require(:event_band).permit(:band_id)
    end

    def set_event
      @event = Event.find(params[:event_id])
    end

    def set_event_band
      @event_band = EventBand.find(params[:id])
    end

end