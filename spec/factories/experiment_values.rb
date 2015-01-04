# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experiment_value do
    experiment "Pricing Test 1"
    variation "$19.99"
    key "price"
    value "1999"
  end
end
