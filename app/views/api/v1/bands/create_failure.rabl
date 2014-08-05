object false

child @band => :band do
  object @band

  node(:full_messages) { |b| b.errors.full_messages }
end