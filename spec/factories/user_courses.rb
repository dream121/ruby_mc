# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_course do
    ignore do
      completed_chapters []
    end

    user
    course
    # order
    # association :order, factory: :order, strategy: :build
    access true
    progress {{'foo' => 'bar'}}

    after(:create) do |user_course, evaluator|
      return unless evaluator.completed_chapters

      progress = {}
      evaluator.completed_chapters.each do |chapter|
        progress[chapter.id.to_s] = {
          'position' => '128',
          'duration' => '128'
        }
      end
      user_course.update_attributes progress: progress
    end
  end
end
