require 'spec_helper'

describe PaymentProcessor do

  let(:cart) { create :cart }
  let(:amount) { 10000 }
  let(:description) { 'Payment Description' }
  let(:processor) { PaymentProcessor.new }

  describe '#refund!' do
    let(:refund_amount) { 1000 }
    let(:transaction_id) { 'ch_102o9Q2zE6DXCiQZ9beo1TTY' }

    before do
      VCR.use_cassette('successful_refund') do
        processor.refund!(refund_amount, transaction_id)
      end
    end

    it 'stores values representing the successful refund' do
      expect(processor.errors).to be_nil
      expect(processor.amount_refunded).to eq(1000)
      expect(processor.refunded).to be_false  # not refunded in full
      expect(processor.paid).to be_true       # not refunded in full
    end
  end

  describe '#charge!' do
    context 'with a successful response' do
      # Card: 4242424242424242
      let(:token) { 'tok_102o7I2zE6DXCiQZo1Nd8QMR' }

      before do
        VCR.use_cassette('successful_charge') do
          processor.charge!(amount, token, description)
        end
      end

      it 'stores values representing the successful charge' do
        expect(processor.paid).to be_true
        expect(processor.errors).to be_nil
        expect(processor.amount).to eq(10000)
      end

      it 'saves the JSON response' do
        expect { JSON.parse(processor.response) }.to_not raise_exception
      end

      ## TODO: move this to OrderProcessor spec
      # it 'returns a saved order' do
      #   expect(@order.persisted?).to be_true
      #   expect(@order.course).to eq(cart.course)
      #   expect(@order.user).to eq(cart.user)
      # end
    end

    context 'with a declined card' do
      # Card: 4000000000000002
      let(:token) { 'tok_102o8D2zE6DXCiQZUVFUygj5' }

      before do
        VCR.use_cassette('declined_card') do
          processor.charge!(amount, token, description)
        end
      end

      it 'stores values representing the declined charge' do
        expect(processor.paid).to be_false
        expect(processor.errors).to eq('Your card was declined.')
      end

      it 'saves the JSON response' do
        expect { JSON.parse(processor.response) }.to_not raise_exception
        expect(JSON.parse(processor.response)['error']['code']).to eq("card_declined")
      end
    end

    context 'with a processing error' do
      # Card: 4000000000000119
      let(:token) { 'tok_102o8F2zE6DXCiQZn9iHsBIM' }

      before do
        VCR.use_cassette('processing_error') do
          processor.charge!(amount, token, description)
        end
      end

      it 'stores values representing the declined charge' do
        expect(processor.paid).to be_false
        expect(processor.errors).to eq("An error occurred while processing your card. Try again in a little bit.")
      end

      it 'saves the JSON response' do
        expect { JSON.parse(processor.response) }.to_not raise_exception
        expect(JSON.parse(processor.response)['error']['code']).to eq("processing_error")
      end
    end

    context 'with a $0 amount' do
      before do
        processor.charge!(0, nil, description)
      end

      it 'stores values representing the successful charge' do
        expect(processor.paid).to be_true
        expect(processor.errors).to be_nil
        expect(processor.amount).to eq(0)
      end

      it 'saves the JSON response' do
        expect { JSON.parse(processor.response) }.to_not raise_exception
      end
    end
  end

end
