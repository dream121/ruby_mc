class CourseReview < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true

  def self.visible
    where(visible: true)
  end

  def self.featured
    where(featured: true)
  end
end
