# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :save, :class => 'Save' do
    user_id 1
    event_id 1
  end
end
