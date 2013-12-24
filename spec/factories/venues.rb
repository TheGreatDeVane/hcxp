# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name Faker::Name.name
    address Faker::Address.street_address(include_secondary: false)
  end
end
