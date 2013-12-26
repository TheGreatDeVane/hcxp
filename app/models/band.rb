class Band < ActiveRecord::Base
  extend FriendlyId
  searchkick autocomplete: [:name]

  friendly_id :name, use: :slugged

  has_many :resources, class_name: 'BandResource'

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

  def search_data
    {
      name: name,
      location: location
    }
  end
end
