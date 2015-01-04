require "spec_helper"

describe AdminMailer do
  describe 'invite email' do
    let(:mail) { AdminMailer.invite_email('invite-me@example.com') }

    it 'renders the subject' do
      expect(mail.subject).to eq("[Accomplice] Website invite request from invite-me@example.com")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['team@goaccomplice.com'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['invite-me@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Website invite request from invite-me@example.com")
    end
  end
end
