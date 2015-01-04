# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    thing_type ""
    thing_id ""
    user_id ""
    viewed false
  end
end
