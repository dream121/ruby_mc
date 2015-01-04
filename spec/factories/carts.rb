# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart do
    user

    factory :cart_with_course do
      after(:create) do |cart|
        product = create :course_product
        cart.cart_products.create! product: product, qty: 1, price: product.price
      end

      factory :cart_with_products do
        after(:create) do |cart|
          book = create :book_product
          cart.cart_products.create! product: book, qty: 1, price: book.price
        end
      end
    end
  end
end
