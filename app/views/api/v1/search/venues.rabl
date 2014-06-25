object false

child @venues => :venues do
  collection @venues

  attributes :id, :name, :address
end

node(:resource) { 'venues' }