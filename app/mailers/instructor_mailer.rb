class InstructorMailer < ActionMailer::Base
  default from: "Accomplice <team@goaccomplice.com>"

  def instructor_email(user, course, message)
    @user = user.decorate
    @course = course.decorate
    @body = message.body
    mail(to: @course.instructor_email, from: message.from, subject: "[Accomplice] #{message.subject}")
  end
end
