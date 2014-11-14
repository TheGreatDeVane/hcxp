class Band < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  extend FriendlyId
  include SearchCop

  friendly_id :name, use: :slugged

  search_scope :fulltext_search do
    attributes :name, :location
  end

  default_scope { order(events_count: :desc) }

  has_many :resources, class_name: 'BandResource'
  has_many :event_bands, counter_cache: :events_count
  has_many :events, through: :event_bands
  has_many :story_bands
  has_many :stories, through: :story_bands

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
    lastfm_stories = self.stories.lastfm
    lastfm_stories.first.meta['images'] if lastfm_stories.any? && lastfm_stories.first.meta.present?
  end

  def url
    browse_events_url(q: self.name)
  end

  def foreign_profile_url(type = :bandcamp)
    if resources.bandcamp.any?
      resources.bandcamp.first.url.scan(/http:\/{2}\S*.bandcamp.com/).first
    else
      nil
    end
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    super & %w(name location)
  end
end
