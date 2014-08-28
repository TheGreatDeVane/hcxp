object @event

node(:is_saved) { |e| current_user.saved_events.include? e }