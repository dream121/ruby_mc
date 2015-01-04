class SendWelcomeEmail
  def self.perform
    UserCourseNeedsWelcomeQuery.new.find_each do |user_course|
      user_course.welcomed = true
      user_course.save!
      EmailTemplateMailer.generate(user_course.user, user_course.course, 'welcome').deliver
    end
  end

  class << self
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
    add_transaction_tracer :perform, category: :task
  end
end
