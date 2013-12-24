# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :band do
    name Faker::Name.name
    location "#{Faker::Address.city}, #{Faker::Address.country}"
  end
end
