object false

child @event => :event do
  object @event

  attributes :is_promoted
end

node(:resource) { 'event' }