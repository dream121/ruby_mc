class CourseDecorator < Draper::Decorator
  delegate_all
  delegate :intro_video_id, to: :detail
  delegate :skill, to: :detail
  delegate :role, to: :detail
  delegate :short_description, to: :detail
  delegate :tweet_text, to: :detail
  delegate :featured_review, to: :detail
  delegate :headline, to: :detail
  delegate :overview, to: :detail
  delegate :welcome_statement, to: :detail
  delegate :welcome_back_statement, to: :detail

  def instructor
    instructors.first
  end

  def instructor_name
    if instructor
      instructor.name
    end
  end

  def instructor_first_name
    name = instructor_name
    if name
      name.split(/\s+/).first
    end
  end

  def instructor_last_name
    name = instructor_name
    if name
      name.split(/\s+/).last
    end
  end

  def instructor_email
    if instructor
      instructor.email
    end
  end

  def instructor_short_bio
    if instructor
      instructor.short_bio
    end
  end

  def instructor_testimonials
    instructor = instructors.first
    if instructor
      instructor.testimonials
    end
  end

  def instructor_headshot_url
    if instructor
      image = instructor.images.find_by kind: 'headshot'
      if image
        image.image.url(:thumb)
      end
    end
  end

  def student_count_formatted
    h.number_with_delimiter(student_count_display, delimiter: ',') if student_count_display
  end

  def get_star_format
    return { full: 5, half: 0, empty: 0 } unless review_average_display
    full  = review_average_display.to_i > 4 ? 5 : review_average_display.to_i
    half  = review_average_display - review_average_display.to_i > 0 ? 1 : 0 unless full == 5
    empty = 5 - (full + half)

    { full: full, half: half , empty: empty }
  end

  def review_average_formatted
  end

  def image_url(kind=:banner, format=:original)
    image = images.find_by kind: kind
    image.image.url(format) if image
  end

  def start_date_formatted
    start_date.strftime("%Y/%M%/%D")
  end

  def live?
    start_date && (start_date <= Time.now)
  end

  def image_kinds
    %w(banner cart class_skills class_hero title class_review class_portrait office_hours enrolled_hero)
  end

  def email_template_kinds
    %w(reminder-1 reminder-2 reminder-3 reminder-4 welcome)
  end

  # chapters

  def next_chapter_path(chapter)
    next_chapter = chapters.detect { |c| c.position == chapter.position + 1 }
    if next_chapter
      h.watch_course_chapter_path(self, next_chapter)
    end
  end

  def previous_chapter_path(chapter)
    previous_chapter = chapters.detect { |c| c.position == chapter.position - 1 }
    if previous_chapter
      h.watch_course_chapter_path(self, previous_chapter)
    end
  end

  # completed chapters

  def up_next(user)
    if completed_lessons(user).present?
      last_completed_chapter_number = completed_lessons(user).map(&:number).max
      chapters_after_last_completed = uncompleted_lessons(user).select do |chapter|
        chapter.number > last_completed_chapter_number
      end
      chapters_after_last_completed.min_by(&:number)
    else
      uncompleted_lessons(user).min_by(&:number)
    end
  end

  # hero images

  def enrolled_hero_kinds
    %w(return_image return_video initial_image initial_video)
  end

  def initial_enrolled_image
    uploads.where('kind = ?', 'initial_image').first
  end

  def initial_enrolled_video
    uploads.where('kind = ?', 'initial_video').first
  end

  def return_enrolled_image
    uploads.where('kind = ?', 'return_image').first
  end

  def return_enrolled_video
    uploads.where('kind = ?', 'return_video').first
  end
end
