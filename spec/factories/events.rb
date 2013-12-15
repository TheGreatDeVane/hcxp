# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "MyString"
    poster "MyString"
    user_id 1
    description "MyText"
    beginning_at "2013-12-15"
    beginning_at_time "2013-12-15 09:55:01"
    ending_at "2013-12-15"
    ending_at_time "2013-12-15 09:55:01"
    price "9.99"
    address nil
    band_list Faker::Lorem.words(3)
  end
end
