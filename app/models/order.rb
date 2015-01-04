class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :coupon
  has_one :payment, dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  validates :user_id, presence: true
  # validate :course_not_purchased

  def courses
    products.select { |p| p.course.present? }.map &:course
  end

  # FIXME: why doesn't this work:
  # has_many :products, through: :order_products
  def products
    order_products.map { |order_product| order_product.product }
  end

  private

  # def course_not_purchased
  #   courses.each do |course|
  #     if user && user.courses.include?(course)
  #       errors.add(:base, "You have already purchased #{course.name}")
  #     end
  #   end
  # end
end
