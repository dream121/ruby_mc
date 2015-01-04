class PaymentProcessor

  attr_reader :response, :amount, :paid, :errors, :transaction_id
  attr_reader :amount_refunded, :refunded

  def initialize
    @paid = false
  end

  def charge!(amount, token, description)
    handle_errors do
      if amount > 0
        do_stripe_charge(amount, token, description)
      else
        do_dummy_charge
      end
    end
  end

  def refund!(amount, transaction)
    handle_errors do
      refund = create_refund(amount, transaction)
      @response = refund.to_json
      @amount_refunded = refund.amount_refunded
      @refunded = refund.refunded
      @transaction_id = refund.id
      @paid = refund.paid
    end
  end

  private

  def do_stripe_charge(amount, token, description)
    charge = create_charge(amount, token, description)
    @response = charge.to_json
    @amount = charge.amount
    @paid = charge.paid
    @transaction_id = charge.id
  end

  def do_dummy_charge
    @response = '{}'
    @amount = 0
    @paid = true
    @transaction_id = nil
  end

  def create_charge(amount, token, description)
    Stripe::Charge.create(
      amount: amount,
      currency: "usd",
      card: token, # obtained with Stripe.js
      description: description
    )
  end

  def create_refund(amount, transaction)
    charge = Stripe::Charge.retrieve(transaction)
    charge.refund(amount: amount)
  end

  def handle_errors(&block)
    begin
      yield
    rescue Stripe::CardError => e
      @response = e.http_body
      @errors = e.json_body[:error][:message]

      # puts "Status is: #{e.http_status}"
      # puts "Type is: #{err[:type]}"
      # puts "Code is: #{err[:code]}"
      # puts "Param is: #{err[:param]}"
      # puts "Message is: #{err[:message]}"
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      @response = e.http_body
      @errors = 'Invalid request'
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      @response = e.http_body
      @errors = 'Authentication error'
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      @response = e.http_body
      @errors = 'Connection error'
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      @response = e.http_body
      @errors = 'Payment processor error'
    rescue => e
      @errors = e.inspect
      # Something else happened, completely unrelated to Stripe
    end
  end
end
