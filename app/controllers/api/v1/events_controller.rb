class Api::V1::EventsController < Api::V1Controller
  before_action :authenticate_user!
  before_action :set_event, only: [:promote]
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

  private

    def set_event
      @event = Event.find(params[:id])
    end

end