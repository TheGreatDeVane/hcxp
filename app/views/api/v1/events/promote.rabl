object false

child @event => :event do
  object @event

  attributes :id, :is_promoted
end

node :meta do
  {
    resource: 'event'
  }
end