class CourseComment < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  belongs_to :chapter
  has_many :notifications, as: :notifiable

  has_one :image, as: :imageable, dependent: :destroy
  scope :descendants_and_children, lambda { |course_id, chapter_id, depth| where("parent_id IN (select id from course_comments where (nlevel(path) = ?) and course_comments.course_id = ? and course_comments.chapter_id = ?) OR id IN (select id from course_comments where (nlevel(path) = ?) and course_comments.course_id = ? and course_comments.chapter_id = ?)", depth, course_id, chapter_id, depth, course_id, chapter_id) }
  scope :descendants_only, lambda { |course_id, chapter_id, depth| where(parent_id: self.select(:id).at_depth(depth).where(course_id: course_id, chapter_id: chapter_id)) }
  scope :roots_only, lambda { |course_id, chapter_id, depth| self.at_depth(depth).where(chapter_id: chapter_id, course_id: course_id) }

  # CTE scopes for focusing on one record and surrounding records
  scope :previous_items,  -> (date, parent_id) { where("created_at <= ? AND parent_id = ?", date, parent_id).order('created_at DESC').limit(5) }
  scope :next_items,      -> (date, parent_id) { where("created_at > ? AND parent_id = ?", date, parent_id).order('created_at DESC').limit(5) }
  scope :this_item,       -> (id) { where(id: id) }

  def self.focus_group(date, parent_id, id)
    self.previous_items(date, parent_id).union(next_items(date, parent_id))
  end

  # MC SEARCH ITEMS
  include McSearch
  RESULT_LIMIT = 1000
  DEFAULT_SET_AMOUNT = 5
  DEFAULT_SORT_ORDER  = 'desc'
  DEFAULT_SORT_COLUMN = 'created_at'
  DEFAULT_PAGE_NO = 1

  ATTR_MAP = {
    id:         { match: 'exact' },
    course_id:  { match: 'exact' },
    user_id:    { match: 'exact' },
    parent_id:  { match: 'exact' },
    votes:      { match: 'gteq' }
  }

  SEARCH_PATH = '/api/v1/course_comments'

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
    '/api/v1/course_comments'
  end
  # END MC SEARCH ITEMS

  has_ltree_hierarchy

  def self.for_course (course)
    where('course_id = ? AND parent_id IS NULL', course.id).order(:created_at).includes(:parent)
  end

  def self.return_remaining_comments(attributes = {})
    # START LOGIC TO DETERMINE PREVIOUS OR NEXT QUERY
    id      = attributes[:last_id].present? ? attributes[:last_id] : attributes[:prev_id]
    comment = self.where(id: id).first
    exp     = attributes[:last_id].present? ? "id < ?" : "id > ?"
    # END LOGIC TO DETERMINE PREVIOUS OR NEXT QUERY

    comments  = where("#{exp}", id).where(parent_id: comment.parent_id).order('created_at asc')#.at_depth(attributes[:depth])
    count     = comments.count
    position  = nil
    before    = 0
    after     = 0

    api_result = {
      last_id: comments.last.id,
      first_id: comments.first.id,
      result_set: comments,
      prev_page_url: nil,
      next_page_url: nil,
      total_items: count,
      items_left: after,
      items_before: before,
      focus_depth: nil,
      focus_id: nil,
    }
  end

  def self.focused_search(attributes = {})
    # LOGIC STRUCTURE TO DETERMINE
    if attributes[:focus_parent_id].nil? # it is the first recurse

      if attributes[:depth] > 2 # the comment is nested.
        comment                       = self.find(attributes[:parent_id])
        attributes[:focus_id]         = attributes[:comment_id]
        attributes[:focus_parent_id]  = comment[:id]
        attributes[:comment_id]       = comment.id
        attributes[:parent_id]        = comment.parent_id
        attributes[:created_at]       = comment.created_at
        attributes[:depth]            = comment.depth
      else # the comment is not nested

      end

      # Sanitize incoming SQL
      query = self.escape_sql(self.cte_sql, attributes)
      comments = self.find_by_sql(query)

      count = comments.count
      position = comments.map(&:id).index(attributes[:comment_id].to_i)
      after = position
      before = count - (position + 1)
      comments = self.justify_query(comments, position, before, after, count)
      last_id = comments.empty? ? nil : comments.first.id
      first_id = comments.empty? ? nil : comments.last.id
      before = before > 4 ? before - 4 : 0

    else # it is the second recurse and third level

      if attributes[:focus_id].to_i == attributes[:comment_id].to_i # if the focus_id is equal to the id passed in then it is the one
        # Sanitize incoming SQL ## should only happen twice -- once for the parent
        query = self.escape_sql(self.cte_sql, attributes)
        comments = self.find_by_sql(query)
        count = comments.count
        position = comments.map(&:id).index(attributes[:comment_id].to_i)
        after = position
        before = count - (position + 1)
        comments = self.justify_query(comments, position, before, after, count)
        last_id = comments.empty? ? nil : comments.first.id
        first_id = comments.empty? ? nil : comments.last.id
        before = before > 4 ? before - 4 : 0
      else # if it is not then perform a normal query with the parent_id
        total_amount = self.where(parent_id: attributes[:comment_id]).count
        before = total_amount > 5 ? total_amount - 5 : 0
        after = 0
        comments = self.where(parent_id: attributes[:comment_id]).order('created_at desc').limit(5);
        count = comments.count
        last_id = comments.empty? ? nil : comments.first.id
        first_id = comments.empty? ? nil : comments.last.id
      end

    end

    api_result = {
      last_id: last_id,
      first_id: first_id,
      result_set: comments,
      prev_page_url: "/api/v1/course_comments?prev_id=#{last_id}",
      next_page_url: "/api/v1/course_comments?last_id=#{first_id}",
      total_items: count,
      items_left: after,
      items_before: before,
      focus_depth: nil,
      focus_id: attributes[:focus_id],
      focus_parent_id: attributes[:focus_parent_id],
      focused: true,
      requester_id: attributes[:requester_id]
    }
  end

  def self.justify_query(comments, position, before, after, count)
    if before < 4
      if after < ( 4 - after )
        comments
      else
        # comments[0..4]
        comments[(position - 4)..position]
      end
    else
      e = position + 4
      comments[position..e]
    end
  end

  def self.cte_sql
    sql = <<-EOS
      WITH focus_group AS
      (
        (
          SELECT *
          FROM course_comments
          WHERE course_comments.created_at < :created_at
            AND course_comments.id != :comment_id AND course_comments.parent_id = :parent_id
          ORDER BY course_comments.created_at DESC LIMIT :limit
        )
        UNION ALL
        (
          SELECT *
          FROM course_comments
          WHERE course_comments.id = :comment_id
        )
        UNION ALL
        (
          SELECT *
          FROM course_comments
          WHERE course_comments.created_at > :created_at
          AND course_comments.id != :comment_id AND course_comments.parent_id = :parent_id
          ORDER by course_comments.created_at DESC LIMIT :limit
        )
      )
      SELECT * FROM focus_group ORDER BY focus_group.created_at DESC
    EOS

  end

  def self.total_by_user user
    where(user_id: user.id).count
  end

  def latest_comment_time
    if children.last.present?
      children.last.created_at
    else
      100.years.ago
    end
  end
end
