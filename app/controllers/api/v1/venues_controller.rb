class Api::V1::VenuesController < Api::V1Controller
  # before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_action :set_venue, only: [:show]
  # load_and_authorize_resource :event, except: [:find_or_create_tba]

  respond_to :json

  def index
    @venues = Venue.all

    @venues = @venues.where(id: params[:id_in]) if params[:id_in].present?
    @venues = @venues.search(params[:q])        if params[:q].present?
    @venues
  end

  def show
  end

  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      render 'create_success'
    else
      render 'create_failure', status: :unprocessable_entity
    end
  end

  def tba
    @venue = Venue.find_or_create_tba(
      params[:venue][:city],
      params[:venue][:country_code]
    )
  end

  private

    def venue_params
      params.require(:venue).permit(:name, :address, :latitude, :longitude)
    end

    def set_venue
      @venue = Venue.find(params[:id])
    end

end