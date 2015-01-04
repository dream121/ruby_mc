# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_product do
    price 1
    qty 1
    cart nil
    product nil
  end
end
