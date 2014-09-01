attributes :id
attributes :title
attributes :title_or_bands
attributes :description
attributes :views_count
attributes :band_ids
attributes :savegazer_ids
attributes :venue_id
attributes :beginning_at
attributes :price
attributes :is_promoted

node(:saves_count)       { |event| event.saves.count }
node(:beginning_at_time) { |event| event.beginning_at_time.strftime('%H:%M') }
node(:html_url)          { |event| event.url }
node(:excerpt)           { |event| excerpt(event).to_s.truncate(170) }
node(:is_saved)          { |event| current_user.saved_events.include? event } if user_signed_in?

child :savegazers => 'savegazers' do
  collection locals[:object].savegazers

  extends 'api/v1/users/user'
end

child :bands => 'bands' do
  collection locals[:object].bands

  extends 'api/v1/bands/band'
end

child :venue => 'venue' do
  object locals[:object].venue

  extends 'api/v1/venues/venue'
end

node(:permissions) do |event|
  {
  	edit:           can?(:edit, event),
  	toggle_promote: can?(:toggle_promote, event),
  	destroy:        can?(:destroy, event)
  }
end