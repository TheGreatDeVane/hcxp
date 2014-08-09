class Api::V1::UsersController < Api::V1Controller
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def current
    @user = current_user
  end

  def locations
    @locations = current_user.locations
  end

  def locations_create
    @location = current_user.locations.create(location_params)

    if @location
      render json: { success: true, meta: { resource: 'locations' } }
    else
      render json: { success: false }, status: 422
    end
  end

  def locations_destroy
    current_user.locations.find(params[:id]).destroy

    render json: { success: true, meta: { resource: 'locations' } }
  end

  def recent_venues
    @venues = current_user.recent_venues
  end

  private

    def location_params
      params.require(:location).permit(:city, :country_code)
    end

end