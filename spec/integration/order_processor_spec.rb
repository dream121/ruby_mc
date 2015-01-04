require 'spec_helper'

describe OrderProcessor do

  let(:cart) { create :cart }
  let(:user) { cart.user }
  let(:experiments) { nil }
  let(:processor) { OrderProcessor.new(cart, token, experiments) }
  let(:course_product) { create :course_product }
  let(:course) { course_product.course }
  let(:book_product) { create :book_product }
  let(:token) { 'foo' }

  context '#add_product' do
    context 'when the item is not already in the cart' do
      it 'adds the item to the cart' do
        processor.add_product(course_product)
        expect(cart.products).to eq [course_product]
      end
    end

    context 'when the item is already in the cart' do
      it 'does not add the item to the cart' do
        cart.cart_products.create product: course_product, qty: 1, price: course_product.price
        expect { processor.add_product(course_product) }.to_not change {cart.products.count}
      end
    end

    context 'when the user has already purchased the item' do
      it 'does not add the item to the cart' do
        user.user_courses.create! course: course
        expect(processor.add_product(course_product)).to be_false
      end
    end
  end


  context '#remove_product' do
    context 'when the item is not already in the cart' do
      it 'does nothing' do
        processor.remove_product(course_product)
        expect(cart.products).to eq []
      end
    end

    context 'when the item is already in the cart' do
      it 'removes the item' do
        cart.cart_products.create product: course_product, qty: 1, price: course_product.price
        expect { processor.remove_product(course_product) }.to change {cart.products.count}
      end
    end
  end


  context 'for a successful charge' do
    # Test card: 4242424242424242
    let(:token) { 'tok_102oBo2zE6DXCiQZnpjjVOB3' }
    let(:cart) { create :cart_with_course }

    context "when there is no coupon or A/B test price" do
      before do
        VCR.use_cassette('successful_charge') do
          @course = cart.cart_products.first.product.course
          @order = processor.process!
        end
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
        expect(payment.amount).to eq(10000)
        expect(payment.paid).to be_true
        expect(payment.transaction_id).to eq('ch_102oBp2zE6DXCiQZtPSEhiPr')
      end

      it 'creates a UserCourse' do
        user_course = @order.user.user_courses.last
        expect(user_course).to be_a(UserCourse)
        expect(user_course.order).to eq(@order)
        expect(user_course.course).to be_a(Course)
        expect(user_course.course).to eq(@course)
        expect(user_course.access).to be_true
      end

      it 'saves the raw response' do
        payment = @order.payment
        expect(payment.response['object']).to eq('charge')
        expect(payment.response['card']['address_zip']).to eq('94107')
        expect(payment.response['card']['address_zip_check']).to eq('pass')
      end

      it 'deletes the cart' do
        expect { Cart.find(cart.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'for an A/B test price' do
      let(:cart) { create(:cart) }

      before do
        ExperimentValue.create!(experiment: 'Pricing Test 1', variation: '$12.34', key: 'price', value: '1234')
      end

      context 'with a valid experiment value' do
        let(:experiments) { %q({"Pricing Test 1": "$12.34"}) }

        before do
          processor.add_product(course_product)
          payment_processor = double(:processor, paid: true, amount: 1234, response: {}, transaction_id: 567)
          allow(PaymentProcessor).to receive(:new).and_return(payment_processor)
          expect(payment_processor).to receive(:charge!).with(1234, anything, anything) { true }
          VCR.use_cassette('successful_charge') do
            @order = processor.process!
          end
        end

        it 'uses the experiment value as the price' do
          expect(@order.payment.paid).to be_true
          expect(@order.payment.amount).to eq(1234)
        end

        it 'invokes the payment processor with the specified price' do
          expect(@order.new_record?).to be_false
        end
      end

      context 'with an invalid experiment value' do
        let(:experiments) { %q({"Pricing Test 1": "$0.01"}) }

        before do
          processor.add_product(course_product)
          payment_processor = double(:processor, paid: true, amount: 10000, response: {}, transaction_id: 567)
          allow(PaymentProcessor).to receive(:new).and_return(payment_processor)
          expect(payment_processor).to receive(:charge!).with(10000, anything, anything) { true }
          VCR.use_cassette('successful_charge') do
            @order = processor.process!
          end
        end

        it 'uses the course value as the price' do
          expect(@order.payment.paid).to be_true
          expect(@order.payment.amount).to eq(10000)
        end

        it 'invokes the payment processor with the specified price' do
          expect(@order.new_record?).to be_false
        end
      end
    end

    context 'for a cart with a coupon' do
      before do
        cart.coupon = build :coupon, price: 456
      end

      it 'subtracts the coupon value from the total' do
        expect(processor.order_total).to eq(9544)
      end
    end
  end

  context 'for an unsuccessful charge' do
    # Test card: 4000000000000002
    let(:token) { 'tok_102o8D2zE6DXCiQZUVFUygj5' }
    let(:cart) { create :cart_with_course }

    before do
      VCR.use_cassette('declined_card') do
        @order = processor.process!
      end
    end

    it 'does not save an order or payment' do
      expect(@order).to be_nil
    end

    it 'adds errors to the cart' do
      expect(cart.errors.full_messages.to_sentence).to eq('Your card was declined.')
    end

    it 'saves the error response in the cart' do
      expect(cart.reload.response['error']['message']).to eq('Your card was declined.')
    end
  end
end
