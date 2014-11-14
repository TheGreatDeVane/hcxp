class Venue < ActiveRecord::Base
  include SearchCop

  search_scope :fulltext_search do
    attributes :name, :address
  end

  has_many :events

  # Validators
  validates :name, presence: true
  validates :address, presence: true

  # Plugins
  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latitude     = geo.latitude
      obj.longitude    = geo.longitude
      obj.city         = geo.city
      obj.country_name = geo.country
      obj.country_code = geo.country_code

      street_number = geo.address_components.select { |s| s['types'].include? 'street_number' }.first
      street_route  = geo.address_components.select { |s| s['types'].include? 'route' }.first

      formatted_street = (street_number && street_route) ? "#{street_route['short_name']} #{street_number['short_name']}" : nil

      obj.street = formatted_street
    end
  end

  # Callbacks
  before_validation :geocode, if: :address_changed?

  # Validations
  validates :name, presence: true
  with_options if: Proc.new { |e| e.address.present? } do |geo|
    geo.validates :country_name, presence: true
    geo.validates :country_code, presence: true
    geo.validates :city, presence: true
  end

  def to_s
    string = "#{name}"
    string << " - #{street}"      if street.present?
    string << ", #{city}"         if city.present?
    string << ", #{country_name}" if country_name.present?
  end

  def self.find_or_create_tba(latitude, longitude)
    fail ArgumentError, "Latitude and longitude can't be blank" if latitude.blank? || longitude.blank?
    geo = Geocoder.search("#{latitude}, #{longitude}")[0].data['address_components']

    city = geo.select { |c| c['types'].include? 'locality' }.first['long_name']
    country = geo.select { |c| c['types'].include? 'country' }.first['long_name']

    venue = Venue.find_by(name: 'TBA', city: city, country_name: country)
    return venue if venue

    Venue.create(name: 'TBA', address: "#{city}, #{country}")
  end
end
