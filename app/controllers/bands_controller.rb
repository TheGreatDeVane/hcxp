class BandsController < ApplicationController
  before_action :set_band, only: [:show, :past_events, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  load_and_authorize_resource except: [:past_events]

  layout 'single', only: [:show]

  # GET /bands
  def index
    @f = Band.search(params[:f])
    @bands = @f.result.page(params[:page])
  end

  # GET /bands/1
  # GET /bands/1.json
  def show
    @events       = @band.events.from_the(:future).page(params[:page])
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }
    @tab = :future
  end

  def past_events
    @events       = @band.events.from_the(:past).page(params[:page])
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }
    @tab = :past

    render action: :show, layout: 'single'
  end

  # GET /bands/autocomplete
  # GET /bands/autocomplete.json
  def autocomplete
    render json: Band.search(params[:q]).map(&:name)
  end

  # GET /bands/1/edit
  def edit
  end

  # PATCH/PUT /bands/1
  # PATCH/PUT /bands/1.json
  def update
    respond_to do |format|
      if @band.update(band_params)
        format.html { redirect_to @band, notice: 'Band was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @band.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_band
      @band = Band.friendly.find(params[:id]).decorate
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def band_params
      params.require(:band).permit(
        :name, :location, :city, :country_name, :country_code,
        resources_attributes: [:id, :resource_type, :url, :user_id, :_destroy]
      )
    end
end
