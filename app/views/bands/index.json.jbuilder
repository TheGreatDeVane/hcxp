json.array!(@bands) do |band|
  json.extract! band, :id, :name, :location, :city, :country_name, :country_code
  json.url band_url(band, format: :json)
end
