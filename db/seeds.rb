print 'Seeding database '

# Create bands
Band.create!([
  {
    name:     'Judge',
    location: 'New York, USA'
  },
  {
    name:     'Youth of Today',
    location: 'Danbury, USA'
  },
  {
    name:     'Turnstile',
    location: 'USA'
  }
])
print '.'

# Create venue
Venue.create!(
  name:    'TBA',
  address: 'Krakow, Poland'
)
print '.'

# Create user
User.create!(
  username: 'test_user',
  email:    'email@email.com',
  password: 'TestPass',
  is_admin: true
)
print '.'

# Create events
20.times do
  event = Event.create!(
    title:              Faker::Lorem.sentence,
    description:        Faker::Lorem.paragraphs(2).join("\n\n"),
    band_ids:           (Band.all.map(&:id) if [true, false].sample),
    beginning_at:       DateTime.now + rand(1...10).month,
    beginning_at_time: '19:00',
    price:              '20 PLN',
    venue_id:           Venue.last.id,
    user_id:            User.last.id
  )
  print '.'
end

puts '.'