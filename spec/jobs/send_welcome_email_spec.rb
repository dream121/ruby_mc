require 'spec_helper'

describe SendWelcomeEmail do
  let(:course) { create :course }

  before do
    course.email_templates.create(
      kind: "welcome",
      from: "Alton Brown <instructor@example.com>",
      subject: "Hi <%= @user.first_name %> - welcome to class!",
      body: "Welcome to <%= course.title =>!"
    )

    Timecop.freeze(1.day.ago) do
      @user_course = create :user_course, course: course
    end
  end

  it 'sends emails to all new customers' do
    expect { SendWelcomeEmail.perform }.to change { ActionMailer::Base.deliveries.length }.by(1)
  end

  it 'sets the welcomed flag to true' do
    SendWelcomeEmail.perform
    @user_course.reload
    expect(@user_course.welcomed).to be_true
  end

end
