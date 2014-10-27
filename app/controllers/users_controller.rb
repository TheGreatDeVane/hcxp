class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @f = User.search(params[:f])
    @users = @f.result.page(params[:page])
  end

  def saves
    @events       = current_user.saved_events.order(:beginning_at)
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }

    render 'events/index'
  end

  def events
    @events       = current_user.events.order(:beginning_at)
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }

    render 'events/index'
  end
end