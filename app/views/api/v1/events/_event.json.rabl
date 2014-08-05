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

node(:saves_count) { |event| event.saves.count }
node(:beginning_at_time) { |event| event.beginning_at_time.strftime('%H:%M') }

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