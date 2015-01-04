require 'spec_helper'

describe CartsController do

  let(:cart) { create :cart }

  def valid_session
    {}
  end

  context "for a customer" do
    let(:user) { create :user }
    let(:product) { create :course_product }
    let(:course) { product.course }

    before do
      sign_in user
    end

    describe "#add_product" do
      context 'when no cart exists' do
        it 'creates a cart and adds the product to it' do
          get :add_product, { product_id: product.to_param }, valid_session
          cart = assigns(:cart)
          expect(cart).to be_persisted
          expect(cart.cart_products.length).to eq(1)
          expect(cart.cart_products.first.product).to be_a(Product)
          expect(cart.cart_products.first.product).to eq(product)
          expect(cart.cart_products.first.qty).to eq(1)
          expect(cart.cart_products.first.price).to eq(product.price)
        end
      end
    end

    describe "#remove_product" do
      context 'when a cart with a product exists' do
        let(:user) { cart.user }
        let(:cart) { create :cart_with_course }
        let(:product) { cart.products.last }
        let(:other_product) { create :product }

        before do
          cart
        end

        it 'removes the product the cart' do
          delete :remove_product, { product_id: product.id }, valid_session
          expect(assigns(:cart).cart_products.length).to eq(0)
        end
      end
    end

    describe "#add_coupon" do
      context 'when a cart with a product exists' do
        let(:user) { cart.user }
        let(:cart) { create :cart_with_course }

        before do
          @coupon = create :coupon
        end

        it 'adds the coupon to the cart' do
          post :add_coupon, { code: 'free' }, valid_session
          cart = assigns(:cart)
          expect(cart).to be_persisted
          expect(cart.coupon).to be_a(Coupon)
          expect(cart.coupon).to eq(@coupon)
          expect(cart.coupon.price).to eq(8888)
        end
      end
    end

    describe "#show" do
      before do
        allow_event_tracker 'orders.new', { course: course.title }
      end

      it "assigns the cart as @cart" do
        get :show, {}, valid_session
        expect(assigns(:cart)).to be_a(Cart)
      end
    end
  end

  context "for an admin" do
    before do
      cart
      sign_in build :admin
    end

    describe "#index" do
      it "assigns all carts as @carts" do
        get :index, {}, valid_session
        expect(assigns(:carts)).to eq([cart])
      end
    end

    describe "#destroy" do
      it "destroys the requested cart" do
        expect {
          delete :destroy, { :id => cart.to_param }, valid_session
        }.to change(Cart, :count).by(-1)
      end

      it "redirects to the carts list" do
        delete :destroy, { :id => cart.to_param }, valid_session
        expect(response).to redirect_to(carts_url)
      end
    end
  end
end
