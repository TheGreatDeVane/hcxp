class UsersController < ApplicationController
  before_action :authenticate_user!

  def saves
    @events       = current_user.saved_events.order(:beginning_at)
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }
    @cities       = Venue.all.group(:city)
  end

  def events
    @events       = current_user.events.order(:beginning_at)
    @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }
    @cities       = Venue.all.group(:city)
  end
end