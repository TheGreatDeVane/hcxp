class Api::V1::BandsController < Api::V1Controller
  before_action :authenticate_user!, only: [:create]
  skip_before_filter :verify_authenticity_token
  before_action :set_band, only: [:show]

  respond_to :json

  def index
    @q = Band.search(params[:f])
    @bands = @q.result.page(params[:page])
  end

  def create
    @band = Band.new(band_params)

    if @band.save
      render 'create_success'
    else
      render 'create_failure', status: :unprocessable_entity
    end
  end

  private

    def band_params
      params.require(:band).permit(:name, :location)
    end

    def set_band
      @band = Band.find(params[:id])
    end

end