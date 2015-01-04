class OrderProcessor
  PRICING_EXPERIMENT_NAME = 'Pricing Test 1'

  attr_reader :cart

  def initialize(cart, token=nil, experiments=nil)
    @cart = cart
    @user = cart.user
    @token = token
    @experiments = experiments
  end

  # WARNING: each course in the cart will get the "experiment price" if exists
  def products_total
    @cart.cart_products.inject(0) do |total, cart_product|
      total += (cart_product.qty * cart_product.price)
    end
  end

  def order_total
    total = products_total
    total -= @cart.coupon.price if @cart.coupon.present?
    total < 0 ? 0 : total
  end

  def add_product(product)
    @cart.save if @cart.new_record?
    if @cart.products.include?(product)
      # TODO: set errors on @cart
      return false
    elsif product.course.present? && @user.courses.include?(product.course)
      # TODO: set errors on @cart
      return false
    else
      price = experiment_price || product.price
      @cart.cart_products.create(product: product, qty: 1, price: price)
    end
  end

  def remove_product(product)
    if cart_product = @cart.cart_products.detect { |cp| cp.product == product }
      @cart.cart_products.destroy(cart_product)
    else
      # TODO: set errors on @cart
      return false
    end
  end

  def process!
    description = "Order for #{@user.email}"
    processor = PaymentProcessor.new
    processor.charge!(order_total, @token, description)

    if processor.paid
      @order = create_order(@cart, @user)
      create_user_courses(@order, @user)
      create_payment(@order, processor)
      destroy_cart(@cart)
      redeem_coupon(@cart.coupon)
      send_notification
      return @order
    else
      handle_errors(processor)
      return nil
    end
  end

  private

  def experiment_price
    if @experiments
      begin
        experiments = JSON.parse(@experiments)
        variation = experiments[PRICING_EXPERIMENT_NAME]
        if variation
          experiment_value = ExperimentValue.find_by(
            experiment: PRICING_EXPERIMENT_NAME,
            variation: variation,
            key: 'price'
          )
          if experiment_value
            return experiment_value.value.to_i
          end
        end
      rescue StandardError => e
        # Never fail order processing due to a broken experiment.
        # TODO: send notification?
      end
    end
  end

  def send_notification
    AccountMailer.order_confirmation(@user, @order).deliver
  end

  def create_order(cart, user)
    order = user.orders.build(coupon: cart.coupon)
    cart.cart_products.each do |cart_product|
      order.order_products.build(product_id: cart_product.product.id, qty: cart_product.qty, price: cart_product.price)
    end
    order.save!
    order
  end

  def create_user_courses(order, user)
    order.order_products.each do |order_product|
      if order_product.product.course
        user.user_courses.create!(course: order_product.product.course, order: order)
      end
    end
  end

  def create_payment(order, processor)
    order.create_payment(
      amount: processor.amount,
      paid: processor.paid,
      response: processor.response,
      transaction_id: processor.transaction_id
    )
  end

  def destroy_cart(cart)
    cart.destroy!
  end

  def redeem_coupon(coupon)
    coupon.decorate.redeem! if coupon
  end

  def handle_errors(processor)
    @cart.update_attribute(:response, processor.response)
    @cart.errors.add(:base, processor.errors)
  end

end
