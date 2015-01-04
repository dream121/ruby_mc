# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_detail do
    headline "MyText"
    role "Baker"
    skill "Crusty French Loaves"
    overview "MyText"
    invitation_statement "MyText"
    lessons_introduction "MyText"
    instructor_motivation "MyText"
    welcome_statement "Welcome!"
    welcome_back_statement "Welcome Back!"
    total_video_duration "MyString"
    intro_video_id "MyString"
    short_description "Bread is delicious"
    course

    factory :detail
  end

end
