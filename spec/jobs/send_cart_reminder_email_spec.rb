require 'spec_helper'

describe SendCartReminderEmail do
  let(:course) { create :course, title: "Test Course" }
  let(:user) { create :user, email: "test@example.com" }
  let(:cart) { create :cart, course: course, user: user }

  before do
    course.email_templates.create(
      kind: "reminder-1",
      from: "Accomplice <team@goaccomplice.com>",
      subject: "A Reminder for <%= @course.title %>",
      body: "Hi, <%= @user.first_name %>:"
    )

    Timecop.freeze(1.day.ago) do
      @cart1 = create :cart, course: course, user: user
    end

    Timecop.freeze(3.hours.ago) do
      @cart2 = create :cart, course: course, user: user
    end
  end

  it 'sends emails to abandoned carts' do
    expect { SendCartReminderEmail.perform }.to change { ActionMailer::Base.deliveries.length }.by(1)
  end

  it 'sets the reminder_count to the correct value for the time window' do
    SendCartReminderEmail.perform

    @cart1.reload
    expect(@cart1.reminder_count).to eq(2)

    @cart2.reload
    expect(@cart2.reminder_count).to eq(1)
  end
end
