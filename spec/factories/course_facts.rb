# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_fact do
    course
    kind "statistic"
    position 1
    icon "fa fa-briefcase"
    number 15
    title "Documents"
    description "This course has many documents"
  end
end
