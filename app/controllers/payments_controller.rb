class PaymentsController < ApplicationController
  before_action :require_login
  before_action :set_order
  before_action :set_payment
  after_filter :verify_authorized

  def edit
  end

  def refund
    cents = amount_cents(params[:amount])
    processor = RefundProcessor.new(@payment, cents)
    @payment = processor.process!
    if @payment.errors.any?
      flash[:error] = @payment.errors.full_messages.to_sentence
    else
      flash[:notice] = 'Payment was successfully refunded.'
    end
    render action: 'edit'
  end

  private

  def amount_cents(amount_dollars)
    (BigDecimal.new(amount_dollars) * 100).to_i
  end

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_payment
    @payment = Payment.find(params[:id])
    authorize(@payment)
  end
end
