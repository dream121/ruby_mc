require 'spec_helper'

describe OrderConverter do
  let(:converter) { OrderConverter.new }
  let(:user_course) { create :user_course }
  let(:product) { Product.create! course_id: course.id, price: 999 }
  let(:course) { user_course.course }
  let(:user) { user_course.user }
  let(:order) { Order.create! course: course, user: user }

  context "for a converter" do
    before do
      product
    end

    it 'converts an order from the old format to the new' do
      ActiveRecord::Base.transaction do
        converter.convert!(order)
        order.reload
        expect(order.order_products.length).to eq(1)
        expect(order.order_products.first.product).to eq(product)
      end
    end
  end
end
