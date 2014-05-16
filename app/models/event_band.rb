class EventBand < ActiveRecord::Base
  belongs_to :event
  belongs_to :band

  after_create :update_band_events_counter_cache
  after_destroy :update_band_events_counter_cache

  private

    def update_band_events_counter_cache
      band.update_attribute(:events_count, band.events.length)
    end
end
