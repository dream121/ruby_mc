# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_comment do
    course nil
    user nil
    comment "MyText"
    parent_id nil
    path ""
  end
end
