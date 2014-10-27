class SavesController < ApplicationController
  def toggle
    if params[:event_id].present?
      event = Event.find(params[:event_id])
      event.toggle_save(current_user)

      redirect_to event.path
    end
  end
end