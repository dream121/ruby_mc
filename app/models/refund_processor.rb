class RefundProcessor
  def initialize(payment, amount)
    @payment = payment
    @amount = amount
  end

  def process!
    processor = PaymentProcessor.new
    processor.refund!(@amount, @payment.transaction_id)

    if processor.errors
      handle_errors(processor)
    else
      update_payment(processor)
    end
    @payment
  end

  private

  def update_payment(processor)
    @payment.update_attributes!(
      amount_refunded: processor.amount_refunded,
      paid: processor.paid,
      refunded: processor.refunded,
      response: processor.response
    )
  end

  def handle_errors(processor)
    @payment.errors.add(:base, processor.errors)
  end

end
