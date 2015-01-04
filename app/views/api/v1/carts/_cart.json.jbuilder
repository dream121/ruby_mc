json.course do
  json.partial! 'api/v1/courses/course', course: cart.course
end

if cart.coupon
  json.coupon do
    json.partial! 'api/v1/coupons/coupon', coupon: cart.coupon
  end
end
