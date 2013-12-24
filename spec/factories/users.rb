# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email    Faker::Internet.email
    password 'TestPass666'
    username Faker::Lorem.characters(10)
  end
end
