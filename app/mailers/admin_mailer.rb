class AdminMailer < ActionMailer::Base
  default from: "Accomplice <team@goaccomplice.com>"
  default to: "Accomplice <team@goaccomplice.com>"

  def invite_email(from)
    @from = from
    mail(from: from, subject: "[Accomplice] Website invite request from #{from}")
  end
end
