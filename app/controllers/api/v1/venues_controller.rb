class Api::V1::VenuesController < Api::V1Controller
  # before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_action :set_venue, only: [:show]
  # load_and_authorize_resource :event, except: [:find_or_create_tba]

  respond_to :json

  def index
    response.headers['X-Resource'] = 'venues'

    @venues = Venue.all
    @venues = @venues.search(params[:query])
    @venues
  end

  def show
  end

  def create
    response.headers['X-Resource'] = 'venue'

    @venue = Venue.new(venue_params)

    if @venue.save
      render json: {
        success: true,
        venue: {
          id: @venue.id
        }
      }
    else
      render json: {
        venue: {
          errors:        @venue.errors,
          full_messages: @venue.errors.full_messages,
        }
      }, status: :unprocessable_entity
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