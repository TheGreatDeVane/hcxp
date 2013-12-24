json.array!(@venues) do |venue|
  json.extract! venue, :id, :name, :address, :street, :city, :country_name, :country_code
  json.url venue_url(venue, format: :json)
end
