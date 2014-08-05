object false

child @venue => :venue do
  object @venue

  node(:full_messages) { |b| b.errors.full_messages }
end