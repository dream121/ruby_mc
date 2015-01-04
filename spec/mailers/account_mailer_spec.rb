require "spec_helper"

describe AccountMailer do

  let(:smtp_api_header_value) { "{\"filters\":{\"bypass_list_management\":{\"settings\":{\"enable\":1}}}}" }

  describe 'password_reset' do
    let(:identity) { create :identity, password_reset_token: 'TOKEN' }
    let(:mail) { AccountMailer.password_reset(identity) }

    it 'renders the subject' do
      expect(mail.subject).to eq("Your Password Reset Request")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([identity.email])
    end

    it 'renders the sender email' do
      expect(mail.from.first).to match(%r(team@goaccomplice.com))
    end

    it 'renders the reset token link' do
      expect(mail.body.encoded).to match(%r(password_resets/TOKEN))
    end

    it 'sets the X-SMTPAPI header to bypass list management' do
      expect(mail['X-SMTPAPI'].value).to eq(smtp_api_header_value)
    end
  end

  describe 'order_confirmation' do
    let(:order) { create :order, payment: build(:payment, order: nil) }
    let(:user) { order.user.decorate }
    let(:course) { order.courses.last }
    let(:mail) { AccountMailer.order_confirmation(user, order) }

    before do
      course.instructors << create(:instructor)
    end

    it 'renders the subject' do
      expect(mail.subject).to eq("Tom, You're Now An Accomplice! (Order Confirmation)")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['team@goaccomplice.com'])
    end

    it 'renders the course title' do
      expect(mail.body.encoded).to match(course.title)
    end

    it 'renders the course price' do
      expect(mail.body.encoded).to match(/\$100\.00/)
    end

    it 'renders the instructor name' do
      expect(mail.body.encoded).to match("Alton Brown")
    end

    it 'sets the X-SMTPAPI header to bypass list management' do
      expect(mail['X-SMTPAPI'].value).to eq(smtp_api_header_value)
    end
  end

end
