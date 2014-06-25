object false

child @bands => :bands do
  collection @bands

  attributes :id, :name, :location, :images
end

node(:resource) { 'bands' }