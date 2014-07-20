object false

child @event => :event do
  object @event

  node(:is_saved) { |e| current_user.saved_events.include? e }
end

node(:resource) { 'event' }