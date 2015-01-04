require 'spec_helper'

describe OrderProcessor do

  let(:cart) { create :cart_with_course }
  let(:coupon) { build :coupon }
  let(:token) { 'abc' }
  let(:experiments) { nil }
  let(:processor) { OrderProcessor.new(cart, token, experiments) }

  context 'for a successful charge' do

    context 'for a cart with no coupon' do
      before do
        PaymentProcessor.any_instance.stub(charge!: true, amount: 1000, paid: true, response: { 'foo' => 'bar' })
        @course = cart.cart_products.first.product.course
        @order = processor.process!
      end

      it 'creates an order' do
        expect(@order.new_record?).to be_false
        expect(@order.order_products.length).to eq(1)
        expect(@order.order_products.first.product.course).to be_a(Course)
        expect(@order.order_products.first.product.course).to eq(@course)
        expect(@order.user).to eq(cart.user)
      end

      it 'creates a payment' do
        payment = @order.payment
        expect(payment).to be_a(Payment)
        expect(payment.persisted?).to be_true
        expect(payment.amount).to eq(1000)
        expect(payment.paid).to be_true
        expect(payment.response).to eq( { 'foo' => 'bar' } )
      end

      it 'creates a UserCourse' do
        user_course = @order.user.user_courses.last
        expect(user_course).to be_a(UserCourse)
        expect(user_course.order).to eq(@order)
        expect(user_course.course).to be_a(Course)
        expect(user_course.course).to eq(@course)
        expect(user_course.access).to be_true
      end
    end

    context 'for a cart with a coupon' do
      before do
        cart.coupon = coupon
        cart.save
        PaymentProcessor.any_instance.stub(charge!: true, amount: 8888, paid: true, response: { 'foo' => 'bar' })
        @order = processor.process!
      end

      it 'creates an order with a coupon' do
        expect(@order.new_record?).to be_false
        expect(@order.user).to eq(cart.user)
        expect(@order.coupon).to eq(cart.coupon)
      end

      it 'creates a payment' do
        payment = @order.payment
        expect(payment).to be_a(Payment)
        expect(payment.persisted?).to be_true
        expect(payment.amount).to eq(8888)
        expect(payment.paid).to be_true
        expect(payment.response).to eq( { 'foo' => 'bar' } )
      end
    end

    context 'for a cart with a $0 coupon' do
      let(:free_coupon) { build :coupon, price: 0 }

      before do
        cart.coupon = free_coupon
        cart.save
        PaymentProcessor.any_instance.stub(charge!: true, amount: 0, paid: true, response: '{}')
        @order = processor.process!
      end

      it 'creates an order with a coupon' do
        expect(@order.new_record?).to be_false
        expect(@order.user).to eq(cart.user)
        expect(@order.coupon).to eq(cart.coupon)
      end

      it 'creates a payment' do
        payment = @order.payment
        expect(payment).to be_a(Payment)
        expect(payment.persisted?).to be_true
        expect(payment.amount).to eq(0)
        expect(payment.paid).to be_true
        expect(payment.response).to eq({})
      end
    end
  end

  context 'for an unsuccessful charge' do

    before do
      PaymentProcessor.any_instance.stub(charge!: true, amount: 1000, paid: false, response: { 'foo' => 'bar' }, errors: 'oops' )
      @order = processor.process!
    end

    it 'does not save an order or payment' do
      expect(@order).to be_nil
    end

    it 'adds errors to the cart' do
      expect(cart.errors.full_messages.to_sentence).to eq('oops')
    end

  end
end
