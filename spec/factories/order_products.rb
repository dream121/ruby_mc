# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_product do
    price 1
    qty 1
    order nil
    product nil
  end
end
