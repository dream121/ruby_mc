class UserCourseDecorator < Draper::Decorator
  delegate_all
  COMPLETION_THRESHOLD = 90.0

  delegate :chapters, :title, to: :course

  def image_url(kind=:banner, format=:original)
    image = object.course.images.find_by kind: kind
    image.image.url(format) if image
  end

  def welcome_statement
    started? ? course.decorate.welcome_back_statement : course.decorate.welcome_statement
  end

  def progress_for_chapter(chapter_id)
    data = (progress || {})[chapter_id.to_s] || {}
    ChapterProgress.new(data["position"], data["duration"])
  end

  def progress_icon_for_chapter(chapter_id)
    percent_complete = progress_for_chapter(chapter_id).percent_complete
    if percent_complete >= COMPLETION_THRESHOLD
      'icon-checkmark'
    else
      'icon-play'
    end
  end

  def chapters_started
    chapters.find_all {|chapter| chapter_started?(chapter.id)}
  end

  def chapters_completed
    chapters.find_all {|chapter| chapter_completed?(chapter.id)}
  end

  def chapters_uncompleted
    chapters.find_all {|chapter| chapter_completed?(chapter.id) == false}
  end

  def completed?
    chapters_completed.count == Chapter.where(course_id: course.id).count
  end

  def latest_review
    course.reviews_by_user(user).last
  end

  def contributions
    comments.where(user: user).order('created_at DESC')
  end

  class ChapterProgress
    attr_reader :position, :duration

    def initialize(position, duration)
      @position = position.to_f
      @duration = duration.to_f
    end

    def percent_complete
      if @duration > 0.0
        (@position / @duration) * 100
      else
        0.0
      end
    end

    def completed?
      percent_complete >= COMPLETION_THRESHOLD
    end
  end

  def started?
    progress && progress.keys.any? ? true : false
  end

  private

  def chapter_completed?(chapter_id)
    percent_complete = progress_for_chapter(chapter_id).percent_complete
    percent_complete >= COMPLETION_THRESHOLD
  end

  def chapter_started?(chapter_id)
    position = progress_for_chapter(chapter_id).position
    position > 0
  end
end

#  Case 
#  
