attributes :id
attributes :band_id
attributes :event_id
attributes :description

node(:name) { |eb| eb.band.name }
node(:location) { |eb| eb.band.location }
node(:images) { |eb| eb.band.images }