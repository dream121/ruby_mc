require 'spec_helper'

describe RefundProcessor do

  let(:payment) { create :payment }
  let(:amount) { 1000 }
  let(:processor) { RefundProcessor.new(payment, amount) }
  let(:response) { { 'baz' => 'quux' } }

  context 'for a successful refund' do
    before do
      PaymentProcessor.any_instance.stub(refund!: true, amount_refunded: 1000, paid: true, response: response)
      processor.process!
    end

    it 'updates the payment' do
      expect(payment.amount_refunded).to eq(1000)
      expect(payment.paid).to be_true
      expect(payment.response).to eq(response)
    end
  end

  context 'for an unsuccessful refund' do
    before do
      PaymentProcessor.any_instance.stub(refund!: true, response: response, errors: 'oops' )
      processor.process!
    end

    it 'does not update the payment' do
      expect(payment.amount_refunded).to eq(0)
      expect(payment.response).to_not eq(response)
    end

    it 'adds errors to the payment' do
      expect(payment.errors.full_messages.to_sentence).to eq('oops')
    end
  end
end
