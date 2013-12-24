class SavesController < ApplicationController
  before_action :authenticate_user!

  def toggle
    @event = Event.find params[:event_id]

    if current_user.saved_events.include? @event
      current_user.saved_events.delete @event
    else
      current_user.saved_events <<  @event
    end

    respond_to do |format|
      format.js
    end
  end
end