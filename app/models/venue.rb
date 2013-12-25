class Venue < ActiveRecord::Base
  searchkick autocomplete: [:name]
  has_many :events
  
  # Plugins
  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latitude     = geo.latitude
      obj.longitude    = geo.longitude
      obj.city         = geo.city
      obj.country_name = geo.country
      obj.country_code = geo.country_code
      obj.street       = "#{geo.address_components[1]['long_name']} #{geo.address_components[0]['long_name']}"
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
    geo.validates :street, presence: true
  end

  def to_s
    "#{name} - #{street}, #{city}, #{country_name}"
  end

  def search_data
    {
      name: name,
      address: address
    }
  end
end