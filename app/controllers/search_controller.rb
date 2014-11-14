class SearchController < ApplicationController
  def index
    redirect_if_no_query browse_events_path

    @events = Event.visible.fulltext_search params[:q]
    @events = @events.page params[:page]
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }
  end

  def bands
    redirect_if_no_query bands_path

    @bands = Band.fulltext_search params[:q]
    @bands = @bands.page params[:page]
  end

  def users
    redirect_if_no_query users_path

    @users = User.fulltext_search params[:q]
    @users = @users.page params[:page]
  end

  private

  def redirect_if_no_query(path)
    redirect_to path unless params[:q].present?
  end
end