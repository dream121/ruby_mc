class SendCartReminderEmail

  def self.windows
    {
      1 => { from: 23.hours, to: 2.hours },
      2 => { from: 5.days, to: 23.hours },
      3 => { from: 14.days, to: 5.days },
      4 => { from: 30.days, to: 14.days }
    }
  end

  def self.perform
    windows.each do |reminder_number, window|
      carts = AbandonedCartQuery.new.find(window[:from].ago, window[:to].ago, reminder_number)
      carts.each do |cart|
        cart.reminder_count = reminder_number
        cart.save!
        begin
          EmailTemplateMailer.generate(cart.user, cart.course, "reminder-#{reminder_number}").deliver
        rescue EmailTemplateMailer::TemplateNotFound
          # don't require an admin to create all reminders
        end
      end
    end
  end

  class << self
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
    add_transaction_tracer :perform, category: :task
  end
end
