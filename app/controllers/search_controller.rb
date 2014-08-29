class SearchController < ApplicationController
  def index
    # @events  = Event.all

    # # Set defaults
    # params[:when] = (%w(future past).include? params[:when]) ? params[:when] : 'future'

    # # When filter
    # @events = (params[:when] == 'past') ? @events.from_the_past : @events.from_the_future

    # # Band ids filter
    # @events = (params[:band_ids].try(:any?)) ? @events.joins(:bands).where('bands.id IN (?)', params[:band_ids]) : @events

    # # Venue ids filter
    # @events = (params[:venue_ids].try(:any?)) ? @events.joins(:venue).where('venues.id IN (?)', params[:venue_ids]) : @events

    # # Group by months
    # @event_months = @events.group_by { |e| e.beginning_at.beginning_of_day }

    # # Search bands
    # @bands = Band.search(params[:q])

    # # Create a instance variable with all the filters
    # # (for angular)
    # @filters = {
    #   when:      params[:when],
    #   band_ids:  (params[:band_ids].map(&:to_i)  if params[:band_ids]),
    #   venue_ids: (params[:venue_ids].map(&:to_i) if params[:venue_ids]),
    # }

    render 'index'
  end

  def bands
    @bands = Band.search params[:q]

    respond_to do |format|
      format.json
    end
  end
end