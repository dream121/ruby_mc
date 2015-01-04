class OrderConverter

  def convert!(order)
    if order.course && order.course.product && order.order_products.empty?
      order.order_products.create! product: order.course.product, price: order.course.product.price, qty: 1
    else
      puts "Warning: no course for order #{order.id}"
    end
  end
end
