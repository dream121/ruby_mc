# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name "A Product"
    price 10000
    kind "generic"

    factory :course_product do
      name "A Course Product"
      price 10000
      kind "course"
      course
    end

    factory :book_product do
      name "A Book"
      price 2000
      kind "book"
    end
  end
end
