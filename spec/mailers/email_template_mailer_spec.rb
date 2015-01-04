require "spec_helper"

describe EmailTemplateMailer do
  let(:course) { create :course, title: "Test Course" }
  let(:user) { create :user, email: "test@example.com" }
  let(:cart) { create :cart, course: course, user: user }
  let(:instructor) { create :instructor, email: 'instructor@example.com' }

  before do
    course.instructors << instructor
  end

  describe 'welcome' do
    let(:welcome) { EmailTemplateMailer.generate(user, course, "welcome") }

    before do
      course.email_templates.create(
        kind: "welcome",
        from: "Alton Brown <instructor@example.com>",
        subject: "Hi <%= @user.first_name %> - welcome to class!",
        body: "Welcome to <%= @course.title %>!"
      )
    end

    it 'renders the subject' do
      expect(welcome.subject).to eq("Hi Tom - welcome to class!")
    end

    it 'renders the receiver email' do
      expect(welcome.to).to eq(['test@example.com'])
    end

    it 'renders the sender email' do
      expect(welcome.from).to eq(['instructor@example.com'])
    end

    it 'renders the course welcome email text' do
      expect(welcome.body.encoded).to eq('Welcome to Test Course!')
    end

    it 'does not include an X-SMTPAPI header' do
      expect(welcome['X-SMTPAPI']).to be_nil
    end
  end


  describe 'reminder-1' do
    let(:reminder1) { EmailTemplateMailer.generate(user, course, "reminder-1") }

    context "when a reminder email exists" do
      before do
        course.email_templates.create(
          kind: "reminder-1",
          from: "Accomplice <team@goaccomplice.com>",
          subject: "A Reminder for <%= @course.title %>",
          body: "Hi, <%= @user.first_name %>:"
        )
      end

      it 'renders the subject' do
        expect(reminder1.subject).to eq("A Reminder for Test Course")
      end

      it 'renders the receiver email' do
        expect(reminder1.to).to eq(["test@example.com"])
      end

      it 'renders the sender email' do
        expect(reminder1.from).to eq(['team@goaccomplice.com'])
      end

      it 'renders the user name' do
        expect(reminder1.body.encoded).to match("Hi, Tom:")
      end

      it 'does not include an X-SMTPAPI header' do
        expect(reminder1['X-SMTPAPI']).to be_nil
      end
    end

    context "when no reminder email exists" do
      it 'raises an error' do
        expect { reminder1 }.to raise_exception { EmailTemplateMailer::TemplateNotFound }
      end
    end
  end

end
