class Cart < ActiveRecord::Base
  belongs_to :user, inverse_of: :cart
  belongs_to :course
  belongs_to :coupon
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  validates :user_id, presence: true

  def courses
    products.select { |p| p.course.present? }.map &:course
  end
end
