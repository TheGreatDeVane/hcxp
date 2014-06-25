object false

child @venue => :venue do
  object @venue

  extends 'api/v1/venues/venue'
end

node(:resource) { 'venue' }