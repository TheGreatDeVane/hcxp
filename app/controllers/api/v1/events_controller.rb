class Api::V1::EventsController < Api::V1Controller
  before_action :authenticate_user!, only: [:toggle_save, :toggle_promote]
  before_action :set_event, only: [:promote, :toggle_save, :toggle_promote]
  impressionist actions: [:show], unique: [:impressionable_type, :impressionable_id, :session_hash]
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource :event, except: [:similar_by]

  respond_to :json

  def similar_by
    @events = Event.similar_by(
      title:       params[:event][:title],
      description: params[:event][:description],
      bands:       params[:event][:band_list]
    ).reorder('similarity DESC')
  end

  def show; end

  def create
    response.headers['X-Resource'] = 'event'
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      render 'create_success'
    else
      render 'create_failure', status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render 'create_success'
    else
      render 'create_failure', status: :unprocessable_entity
    end
  end

  def toggle_promote
    @event.update_attribute(:is_promoted, !@event.is_promoted)
    @event.reload
  end

  def toggle_save
    if current_user.saved_events.include? @event
      current_user.saved_events.delete @event
    else
      current_user.saved_events <<  @event
    end

    @event.reload
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :remote_poster_url, :user_id, :description,
                                    :beginning_at, :beginning_at_time, :ending_at,
                                    :ending_at_time, :price, :address, {band_ids: []},
                                    :venue_id, :remove_poster, :poster,
                                    :social_link_fb, :social_link_lfm, :social_link_hcpl,
                                    bands_attributes: [:id, :name, :location, :_destroy],
                                    venue_attributes: [:id, :name, :address],
                                    event_bands_attributes: [:id, :band_id, :description, :_destroy]
      )
    end

end