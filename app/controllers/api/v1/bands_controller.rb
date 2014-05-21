class Api::V1::BandsController < Api::V1Controller
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_action :set_band, only: [:show]

  respond_to :json

  def index
    @bands = Band.where(id: params[:id_in])
  end

  private

    def band_params
      params.require(:venue).permit(:name, :address)
    end

    def set_band
      @band = Band.find(params[:id])
    end

end