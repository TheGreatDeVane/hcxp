class Api::V1::EventsController < Api::V1Controller
  before_action :authenticate_user!

  respond_to :json

  def similar_by
    @events = Event.similar_by(
      title:       params[:event][:title],
      description: params[:event][:description],
      bands:       params[:event][:band_list]
    ).reorder('similarity DESC')
  end

end