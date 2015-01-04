class Question < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  has_one :answer
  include McSearch

  # MC SEARCH ITEMS
  RESULT_LIMIT = 5
  DEFAULT_SET_AMOUNT = 5
  DEFAULT_SORT_ORDER  = 'asc'
  DEFAULT_SORT_COLUMN = 'position'
  DEFAULT_PAGE_NO = 1
  ATTR_MAP = {
    id: { match: 'exact' },
    course_id: { match: 'exact' },
    visibility: { match: 'exact' },
  }

  SEARCH_PATH = '/api/v1/questions'

  def self.attr_map
    ATTR_MAP.deep_dup
  end

  def self.result_limit
    RESULT_LIMIT.deep_dup
  end

  def self.default_set_amount
    DEFAULT_SET_AMOUNT.deep_dup
  end

  def self.default_sort_order
    DEFAULT_SORT_ORDER.deep_dup
  end 

  def self.default_sort_column
    DEFAULT_SORT_COLUMN.deep_dup
  end

  def self.default_page_no
    DEFAULT_PAGE_NO.deep_dup
  end

  def self.search_path
    '/api/v1/questions'
  end
  # END MC SEARCH ITEMS

  before_save :assign_position

  has_attached_file :video, :styles => {
    :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
  }, :processors => [:ffmpeg]

  validates_attachment_content_type :video, :content_type => /\Avideo\/.*\Z/

  def assign_position
    if self.position.nil?
      current_max = Question.where(course_id: self.course_id).collect(&:position).compact.max

      if current_max.nil?
        self.position = 1
      else
        self.position = current_max + 1
      end
    end
  end

end
