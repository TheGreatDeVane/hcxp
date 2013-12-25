# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :band_resource do
    band nil
    type ""
    url "MyText"
    data "MyText"
  end
end
