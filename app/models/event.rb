class Event < ActiveRecord::Base
  # Plugins
  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latitude     = geo.latitude
      obj.longitude    = geo.longitude
      obj.city         = geo.city
      obj.country_name = geo.country
      obj.street       = "#{geo.address_components[1]['long_name']} #{geo.address_components[0]['long_name']}"
    end
  end
  acts_as_ordered_taggable_on :bands

  # Callbacks
  before_validation :geocode, if: :address_changed?

  # Validations
  validates :user_id, presence: true
  with_options if: Proc.new { |e| e.address.present? } do |geo|
    geo.validates :country_name, presence: true
    geo.validates :city, presence: true
    geo.validates :street, presence: true
  end
end