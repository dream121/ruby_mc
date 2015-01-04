# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity do
    sequence(:email) { |n| "identity#{n}@example.com" }
    name "Joe Smith"
    password "test"
    password_confirmation "test"
  end
end
