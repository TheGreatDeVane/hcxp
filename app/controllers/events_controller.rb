class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :edit_bands, :update, :destroy, :bands, :toggle]
  before_action :authenticate_user!, only: [:edit, :update, :new, :create]
  impressionist actions: [:show], unique: [:impressionable_type, :impressionable_id, :session_hash]
  load_and_authorize_resource :event, except: [:toggle, :edit_bands]

  layout 'single', only: [:show]

  # GET /events
  # GET /events.json
  def index
    redirect_to browse_events_path
  end

  def browse
    q = params[:q]
    params.merge!(q: {}) unless params[:q].present?
    params[:q][:from_the] = 'future' unless params[:q][:from_the].present?

    @q = Event.visible.search(params[:q])

    @events = @q.result.includes(:bands).includes(:venue).page(params[:page])
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }
  end

  # GET /events/1
  # GET /events/1.json
  def show
    redirect_to @event.path if @event.slug != params[:slug]
  end

  # GET /events/autocomplete
  # GET /events/autocomplete.json
  def autocomplete
    render json: Event.search(params[:q]).limit(10).map(&:title_or_bands)
  end

  # GET /events/new
  def new
    @event = Event.new \
      is_private: true,
      beginning_at_time: '19:00'
  end

  # GET /events/1/edit
  def edit
  end

  def edit_bands
    authorize! :edit, @event
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

  # DELETE /event/1
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Event removed' }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id]).decorate
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(
        :title, :remote_poster_url, :user_id, :description,
        :beginning_at, :beginning_at_time, :ending_at,
        :ending_at_time, :price, :address, {band_ids: []},
        :venue_id, :remove_poster, :poster, :is_canceled, :is_private,
        :is_removed, :social_link_fb, :social_link_lfm,
        bands_attributes:       [:id, :name, :location, :_destroy],
        venue_attributes:       [:id, :name, :address],
        event_bands_attributes: [:id, :band_id, :description, :position, :_destroy]
      )
    end
end
