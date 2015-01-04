# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_review do
    review "MyText"
    rating 1
    name "MyString"
    location "MyString"
    course nil
    user nil
    visible false
    featured false
    position 1
  end
end
