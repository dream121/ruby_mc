# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_template do
    from "MyString"
    subject "MyString"
    body "MyText"
    course nil
    kind "MyString"
  end
end
