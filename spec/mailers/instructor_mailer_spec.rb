require "spec_helper"

describe InstructorMailer do
  describe 'instructor_email' do
    let(:user_course) { create :user_course }
    let(:user) { user_course.user.decorate }
    let(:course) { user_course.course.decorate }
    let(:instructor) { create(:instructor) }
    let(:subject) { "Hi There" }
    let(:body) { "Nice Course" }
    let(:message) { Message.new(subject: subject, body: body, from: user.email, to: instructor.email) }
    let(:mail) { InstructorMailer.instructor_email(user, course, message) }

    before do
      course.instructors << instructor
    end

    it 'renders the subject' do
      expect(mail.subject).to eq("[Accomplice] Hi There")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([instructor.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Nice Course")
    end
  end
end
