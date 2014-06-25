object false

child @locations => :locations do
  collection @locations, root: false, object_root: false

  attributes :id, :city, :country_code
end

node(:resource) { 'locations' }