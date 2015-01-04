namespace :email do
  desc "Send a welcome email to each new customer"
  task send_welcome: :environment do
    SendWelcomeEmail.perform
  end

  task send_cart_reminder: :environment do
    SendCartReminderEmail.perform
  end

  task send_all: [:send_welcome, :send_cart_reminder] do
  end
end
