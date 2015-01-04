# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    user
    after(:create) do |order|
      product = create :course_product
      order.order_products.create! product: product, qty: 1, price: product.price
    end
  end
end
