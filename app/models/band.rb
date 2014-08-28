class Band < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  extend FriendlyId
  include PgSearch

  friendly_id :name, use: :slugged
  pg_search_scope :search, against: [:name, :location],
                           using: {
                             tsearch: { prefix: true }
                           }

  has_many :resources, class_name: 'BandResource'
  has_many :event_bands, counter_cache: :events_count
  has_many :events, through: :event_bands

  validates :name, presence: true, no_capslock: true
  validates :location, presence: true

  # Plugins
  geocoded_by :location do |obj, results|
    if geo = results.first
      obj.city         = geo.city
      obj.country_name = geo.country
      obj.country_code = geo.country_code
    end
  end

  accepts_nested_attributes_for :resources, allow_destroy: true,
                                            reject_if: :all_blank

  # Callbacks
  before_validation :geocode, if: :location_changed?

  def images
    lastfm_resources = self.resources.lastfm
    self.resources.lastfm.first.data[:images] if lastfm_resources.any? && lastfm_resources.first.data.present?
  end

  def url
    search_index_url(q: self.name)
  end

  def foreign_profile_url(type = :bandcamp)
    if resources.bandcamp.any?
      resources.bandcamp.first.url.scan(/http:\/{2}\S*.bandcamp.com/).first
    else
      nil
    end
  end
end
