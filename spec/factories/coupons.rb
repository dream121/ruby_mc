# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    code "free"
    redemptions 1
    max_redemptions 100
    price 8888
    expires_at { 1.year.from_now }
    course
  end
end
