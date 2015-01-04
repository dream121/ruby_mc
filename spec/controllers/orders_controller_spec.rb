require 'spec_helper'

describe OrdersController do

  # This should return the minimal set of attributes required to create a valid
  # Order. As you add validations to Order, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    # attributes_for(:order)
    { user_id: 1, course_id: 1 }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OrdersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe 'for an admin user' do

    before do
      sign_in build :admin
    end

    describe "#index" do
      it "assigns all orders as @orders" do
        order = Order.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:orders)).to eq([order])
      end
    end

    describe "#show" do
      it "assigns the requested order as @order" do
        order = Order.create! valid_attributes
        get :show, { :id => order.to_param }, valid_session
        expect(assigns(:order)).to eq(order)
      end
    end
  end

  describe 'for a logged-in user' do

    let(:user) { create :user }

    before do
      @course = create(:course)
      sign_in user
    end

    describe "#create" do

      let(:token) { 'abc' }
      let(:cart) { user.create_cart(course: @course) }
      let(:payment_double) { double(:payment, paid: true, amount: 10000) }
      let(:order_double) { double(:order, payment: payment_double) }
      let(:order_processor_double) { double(:order_processor, process!: order_double) }
      let(:product) { create :course_product }
      let(:coupon) { build :coupon }
      let(:experiments) { '' }

      before do
        cart
        order_double.stub_chain(:products, :map).and_return(['Product A', 'Product B'])
        order_double.stub_chain(:products, :detect).and_return(product)
        allow(OrderProcessor).to receive(:new).with(cart, token, experiments).and_return { order_processor_double }
        allow_event_tracker 'orders.create', { course: "Product A, Product B", revenue: 10000 }
      end

      after do
        user.cart.destroy!
      end

      context "with valid params" do
        context 'with no AB test pricing' do
          context 'with no coupon' do
            it "calls the order processor with the actual product price" do
              post :create, { stripeToken: token, experiments: experiments }, valid_session
            end

            it "assigns a newly created order as @order" do
              post :create, { stripeToken: token, experiments: experiments }, valid_session
              expect(assigns(:order)).to be(order_double)
            end

            it "does not change the username" do
              expect {
                post :create, { stripeToken: token, experiments: experiments }, valid_session
              }.to_not change { user.name }
            end

            it "redirects to the course" do
              post :create, { stripeToken: token, experiments: experiments }, valid_session
              expect(response).to redirect_to(enrolled_course_path(product.course))
            end
          end
        end

        context 'with AB test pricing' do
          before do
            create :experiment_value
          end

          context 'with valid params' do
            let(:experiments) { { 'Pricing Test 1' => '$19.99'}.to_json }

            it "calls the order processor using the test pricing" do
              post :create, { stripeToken: token, experiments: experiments }, valid_session
            end
          end

          context 'with invalid params' do
            let(:experiments) {{ 'Experiment Foo' => 'Variation Bar'}.to_json }

            it "calls the order processor using the default pricing" do
              post :create, { stripeToken: token, experiments: experiments }, valid_session
            end
          end
        end

        context 'with a name param' do
          it 'sets the user name' do
            expect {
              post :create, { stripeToken: token, name: 'New Name', experiments: experiments }, valid_session
            }.to change { user.name }.to('New Name')
          end
        end
      end

      context "with invalid params" do
        before do
          allow_event_tracker 'orders.create.error', { course: @course.title, message: 'oops' }
          order_double.stub(:payment).and_return nil
          order_double.stub_chain(:errors, :full_messages, :to_sentence).and_return 'oops'
        end

        it "assigns an unsaved order as @order" do
          post :create, { stripeToken: token, experiments: experiments }, valid_session
          expect(assigns(:order)).to be(order_double)
        end

        it "redirects to the cart" do
          post :create, { stripeToken: token, experiments: experiments }, valid_session
          expect(response).to redirect_to(user_cart_path)
        end

        it "sets errors on the flash" do
          post :create, { stripeToken: token, experiments: experiments }, valid_session
          expect(flash[:error]).to eq 'oops'
        end
      end
    end
  end
end
