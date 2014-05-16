class Band < ActiveRecord::Base
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

  validates :name, presence: true
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

  def to_s
    name
  end

  def images
    lastfm_resources = self.resources.lastfm
    self.resources.lastfm.first.data[:images] if lastfm_resources.any? && lastfm_resources.first.data.present?
  end
end
