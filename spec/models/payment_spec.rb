require 'spec_helper'

describe Payment do
  describe "validations" do

    subject { build(:payment) }

    describe "order_id" do
      it "is required" do
        expect(subject).to_not accept_values(:order_id, nil, '', ' ')
      end
    end

    describe "amount" do
      it "is required" do
        expect(subject).to_not accept_values(:amount, nil, '', ' ')
      end

      it "must be an integer" do
        expect(subject).to_not accept_values(:amount, 'asdf')
      end
    end

    describe "paid" do
      it "is required" do
        expect(subject).to_not accept_values(:paid, nil)
      end
    end
  end
end
