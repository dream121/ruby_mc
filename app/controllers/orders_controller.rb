class OrdersController < ApplicationController
  before_action :require_sign_up
  before_action :set_order, only: [:show, :destroy]
  before_action :set_admin, only: [:show, :index]
  after_filter :verify_authorized, except: [:create]
  force_ssl if: :ssl_configured?, only: [:new, :create]

  def index
    authorize(Order)
    @orders = Order.all.order('created_at DESC')
  end

  def show
  end

  def create
    set_user_name if params[:name]
    @cart = current_user.cart
    processor = OrderProcessor.new(@cart, params[:stripeToken], params[:experiments])
    @order = processor.process!

    if @order
      if @order.payment.try(:paid)
        revenue = @order.payment.amount
        names = @order.products.map(&:name).join(', ')
        track_event 'orders.create', course: names, revenue: revenue
        session[:revenue] = revenue
        course_product = @order.products.detect {|p| p.course.present? }
        if course_product
          redirect_to enrolled_course_url(course_product.course, protocol: 'http://'), notice: 'Thank you for your order!'
        else
          redirect_to courses_path, notice: 'Thank you for your order!'
        end
      else
        message = @order.errors.full_messages.to_sentence
        track_event 'orders.create.error', course: @cart.course.title, message: message
        flash[:error] = message
        redirect_to user_cart_path
      end
    else
      flash[:error] = processor.cart.errors.full_messages.to_sentence
      redirect_to user_cart_path
    end
  end

  def destroy
    if @order.destroy
      redirect_to orders_path, notice: 'Order was successfully destroyed.'
    else
      flash[:error] = @order.errors.full_messages.to_sentence
      render action: 'edit'
    end
  end

  private

  def ssl_configured?
    Rails.env.production?
  end

  def set_order
    @order = Order.find(params[:id])
    authorize(@order)
  end

  def set_course
    @course = Course.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    params.require(:order).permit(:user_id, :course_id)
  end

  def set_user_name
    current_user.name = params[:name]
    current_user.save
  end
end
