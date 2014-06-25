object false

child @venues => :venues do
  collection @venues

  extends 'api/v1/venues/venue'
end

node(:resource) { 'venues' }