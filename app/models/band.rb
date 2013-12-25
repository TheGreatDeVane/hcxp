class Band < ActiveRecord::Base
  searchkick autocomplete: [:name]

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

  # Callbacks
  before_validation :geocode, if: :location_changed?

  def to_s
    name
  end

  def search_data
    {
      name: name,
      location: location
    }
  end
end
