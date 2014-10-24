attributes :id
attributes :band_id
attributes :event_id
attributes :description
attributes :position

child(:band) do |eb|
  extends 'api/v1/bands/band'
end