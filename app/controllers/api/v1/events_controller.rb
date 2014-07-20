class Api::V1::EventsController < Api::V1Controller
  before_action :authenticate_user!, only: [:toggle_save]
  before_action :set_event, only: [:promote, ]
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

  def promote
    @event.update_attribute(:is_promoted, !@event.is_promoted)
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

end