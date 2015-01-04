class Course < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title,
            presence: true,
            uniqueness: true

  # validates :role,
  #           presence: true

  # validates :skill,
  #           presence: true

  # validates :short_description,
  #           presence: true

  # TODO: remove price field
  validates :price,
            presence: true,
            numericality: { only_integer: true }

  validates :slug,
            presence: true

  has_and_belongs_to_many :instructors
  belongs_to :order

  has_many :images, as: :imageable, dependent: :destroy
  has_many :uploads, -> { order "id ASC" }, as: :uploadable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :user_courses#, inverse_of: :courses
  has_many :students, source: :user, through: :user_courses
  has_many :email_templates, dependent: :destroy
  has_many :coupons, dependent: :destroy
  has_many :comments, class_name: 'CourseComment', dependent: :destroy
  has_many :reviews, class_name: 'CourseReview', dependent: :destroy
  has_many :facts, class_name: 'CourseFact', dependent: :destroy

  has_many :chapters
  has_one :product, dependent: :destroy

  has_one :detail, class_name: 'CourseDetail', dependent: :destroy
  has_many :questions

  scope :recommended,       ->  { where(available_now: true) }
  scope :coming,            ->  { where(available_now: false) }

  accepts_nested_attributes_for :detail

  def self.for_user(user)
    user.courses
    # joins('JOIN orders ON orders.course_id = courses.id').where('orders.user_id' => user.id)
  end

  def self.recommended_for_user(user)
    finder = where.not(id: user.courses.collect(&:id))
    finder = finder.recommended
  end

  def completed_lessons(user)
    self.user_courses.where(user_id: user.id, access: true).first.decorate.chapters_completed.sort_by(&:id)
  end

  def uncompleted_lessons(user)
    self.user_courses.where(user_id: user.id, access: true).first.decorate.chapters_uncompleted.sort_by(&:id)
  end

  def reviewed_by_user(user)
    reviews.where('course_reviews.user_id' => user.id).present?
  end

  def completed_by_user(user)
    completed_lessons(user).count == chapters.count
  end

  def reviews_by_user(user)
    reviews.where(user_id: user.id)
  end

  def chapter_count
    chapters.count
  end
end
