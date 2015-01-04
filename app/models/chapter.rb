class Chapter < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  DURATION_REGEX = /\A(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)\z/

  validates :title, presence: true
  validates :brightcove_id, presence: true
  validates :number, numericality: { only_integer: true }
  validates :duration, presence: true, format: { with: DURATION_REGEX,
    message: "Duration must be in the format HH:MM:SS" }

  belongs_to :course
  acts_as_list scope: :course
  has_many :comments, class_name: 'CourseComment', dependent: :destroy

  def comments
    CourseComment.where('course_id = ? and chapter_id = ? and parent_id IS NOT NULL', self.course_id, self.id)
  end

  def next_for_course
    Chapter.where('course_id = ? and position > ?', self.course_id, self.position).order('position').first
  end

  def previous_for_course
    Chapter.where('course_id = ? and position < ?', self.course_id, self.position).order('position desc').first
  end

  def is_unlocked?(chapters_completed)
    chapters_completed >= unlock_qty
  end
end
