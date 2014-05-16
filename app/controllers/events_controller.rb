class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :bands]
  before_action :authenticate_user!, only: [:edit, :update, :new, :create]

  # GET /events
  # GET /events.json
  def index
    @events       = Event.from_the_future.order(:beginning_at)
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }
  end

  # GET /events/1
  # GET /events/1.json
  def show
    redirect_to @event.path if @event.slug != params[:slug]
    @tab_content_partial = 'info'
  end

  # GET /events/autocomplete
  # GET /events/autocomplete.json
  def autocomplete
    render json: Event.search(params[:q]).limit(10).map(&:title_or_bands)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def bands
    @tab_content_partial = 'bands'
    render action: :show
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      # Transform select2 text field to reails-friendly input
      bands                     = params[:event][:band_ids].to_s.split(';')
      params[:event][:band_ids] = (bands.length) ? bands.each.map { |b| b.split(':')[0] } : nil

      params.require(:event).permit(:title, :remote_poster_url, :user_id, :description,
                                    :beginning_at, :beginning_at_time, :ending_at,
                                    :ending_at_time, :price, :address, {band_ids: []},
                                    :venue_id, :remove_poster, :poster,
                                    :social_link_fb, :social_link_lfm, :social_link_hcpl,
                                    bands_attributes: [:id, :name, :location, :_destroy],
                                    venue_attributes: [:id, :name, :address])
    end
end
