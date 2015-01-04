require 'spec_helper'

describe AbandonedCartQuery do
  let(:windows) { SendCartReminderEmail.windows }

  describe "find" do
    context "when there are several abandoned carts" do
      before do
        @carts = {}
        Timecop.freeze(30.minutes.ago) do
          @carts[0] = create :cart, reminder_count: nil
        end
      end

      context "and they have each received the expected earlier reminders" do
        before do
          windows.each do |reminder_number, window|
            Timecop.freeze(window[:to].ago) do
              @carts[reminder_number] = create :cart, reminder_count: reminder_number - 1
            end
          end
        end

        it 'finds the correct carts for each reminder window' do
          windows.each do |reminder_number, window|
            found = AbandonedCartQuery.new.find(window[:from].ago, window[:to].ago, reminder_number)
            expect(found.to_a).to eq([@carts[reminder_number]])
          end
        end
      end

      context "and they have not received the expected earlier reminders" do
        before do
          windows.each do |reminder_number, window|
            Timecop.freeze(window[:to].ago) do
              @carts[reminder_number] = create :cart, reminder_count: nil
            end
          end
        end

        it 'finds the correct carts for each reminder window' do
          windows.each do |reminder_number, window|
            found = AbandonedCartQuery.new.find(window[:from].ago, window[:to].ago, reminder_number)
            expect(found.to_a).to eq([@carts[reminder_number]])
          end
        end
      end

      context "and they have already received the current reminder" do
        before do
          windows.each do |reminder_number, window|
            Timecop.freeze(window[:to].ago) do
              @carts[reminder_number] = create :cart, reminder_count: reminder_number
            end
          end
        end

        it 'finds the correct carts for each reminder window' do
          windows.each do |reminder_number, window|
            found = AbandonedCartQuery.new.find(window[:from].ago, window[:to].ago, reminder_number)
            expect(found.to_a).to eq([])
          end
        end
      end
    end
  end
end
