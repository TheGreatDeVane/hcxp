object false

child @venues => :venues do
  collection @venues

  attributes :id, :name, :address
end

node :meta do
  {
    resource: 'venues'
  }
end