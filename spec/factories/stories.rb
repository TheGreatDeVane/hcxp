# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :story do
    url "MyString"
    body "MyText"
    user nil
  end
end
