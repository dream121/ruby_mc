require 'spec_helper'

describe PaymentsController do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PaymentsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  let(:payment) { create :payment }
  let(:order) { payment.order }

  before do
    sign_in build :admin
  end

  describe "#edit" do
    it "assigns the requested payment as @payment" do
      get :edit, { :order_id => order.to_param, :id => payment.to_param }, valid_session
      expect(assigns(:payment)).to eq(payment)
    end
  end

  describe "#refund" do
    let(:amount) { 1000 }

    let(:refund_processor_double) { double(:refund_processor, process!: payment) }

    before do
      RefundProcessor.stub(:new).with(payment, amount).and_return refund_processor_double
    end

    describe "with a successful response" do
      it "redirects to the order" do
        put :refund, { order_id: order.to_param, id: order.payment.to_param, amount: '10.00' }, valid_session
        expect(flash[:notice]).to eq 'Payment was successfully refunded.'
        expect(response).to render_template('edit')
      end
    end

    describe "with an error response" do
      before do
        payment.stub_chain(:errors, :any?).and_return true
        payment.stub_chain(:errors, :full_messages, :to_sentence).and_return 'oops'
      end

      it "renders the edit page" do
        put :refund, { order_id: order.to_param, id: order.payment.to_param, amount: '10.00' }, valid_session
        expect(flash[:error]).to eq 'oops'
        expect(response).to render_template('edit')
      end
    end
  end
end
