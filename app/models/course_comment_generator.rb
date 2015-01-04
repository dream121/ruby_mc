class CourseCommentGenerator
  # Active model plumbing
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  ATTRIBUTES = [:comment, :chapter_id, :course_id, :parent_id, :user_id, :visible, :image_url ]
  attr_accessor *ATTRIBUTES

  def initialize(attributes = {})
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", attributes[attribute])
    end
  end

  def parent_comment
    @parent_comment                ||= CourseComment.find(parent_id)
  end

  def chapter
    @chapter                       ||= Chapter.find(chapter_id)
  end

  def user
    @user                          ||= User.find(user_id)
  end

  def course
    @course                        ||= Course.find(course_id)
  end

  def course_comment
    @course_comment                ||= course.comments.new(
      {
        :comment    => comment,
        :chapter_id => chapter_id,
        :user_id    => user_id,
        :visible    => true,
        :image_url  => image_url,
        :parent_id  => parent_id
      }
    )
  end

  def send_notification?
    if parent_comment.depth == 2 ## this is a reply find the owner
      if user_id.to_i == parent_comment.user_id.to_i ## check to see if this is a reply from the owner of the comment
        return false
      else
        return true
      end
    end

  end

  def notification
    @notification                  ||= course_comment.notifications.build(
      {
        :user_id => parent_comment.user_id,
      }
    )
  end

  def save
    return false unless valid?
    if create_objects
      return true
    else
      return false
    end
  end

  private
    def create_objects
      ActiveRecord::Base.transaction do
        course_comment.save!
        notification.save! if send_notification? == true
      end
      return true
    rescue
      false
    end
end
