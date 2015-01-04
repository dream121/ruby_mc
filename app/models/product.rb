class Product < ActiveRecord::Base
  belongs_to :course
  validates :price,
            presence: true,
            numericality: { only_integer: true }
  has_many :recommendations
  has_many :related_products, through: :recommendations

  def self.for_course(course)
    find_by(course_id: course.id)
  end
end
