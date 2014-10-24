class EventBand < ActiveRecord::Base
  belongs_to :event
  belongs_to :band

  acts_as_list scope: :event

  after_create :update_band_events_counter_cache
  after_destroy :update_band_events_counter_cache

  default_scope { order(position: :asc) }

  private

    def update_band_events_counter_cache
      band.update_attribute(:events_count, band.events.length)
    end
end
