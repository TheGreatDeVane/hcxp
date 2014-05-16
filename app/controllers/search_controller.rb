class SearchController < ApplicationController
  def index
    user_id = user_signed_in? ? current_user.id : nil

    @events       = Event.parse_search params[:q], user_id
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }

    @bands = Band.search(params[:q])

    render 'index'
  end

  def bands
    @bands = Band.search params[:q]

    respond_to do |format|
      format.json
    end
  end
end