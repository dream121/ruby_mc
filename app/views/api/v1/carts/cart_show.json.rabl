object @cart
extends 'api/v1/carts/_base'
child(:coupon) { attributes :id, :price, :course_id }
