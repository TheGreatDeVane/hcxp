class SearchController < ApplicationController
  def index
    @events       = Event.search params[:q]
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }
    
    render 'events/index'
  end

  def bands
    @bands = Band.search params[:q]

    respond_to do |format|
      format.json
    end
  end
end