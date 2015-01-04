class Coupon < ActiveRecord::Base
  belongs_to :course
  has_many :orders

  validates :code, :max_redemptions, :course_id, presence: true
end
