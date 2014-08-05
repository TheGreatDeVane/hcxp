object false

child @event => :event do
  object @event

  node(:full_messages) { |e| e.errors.full_messages }
end