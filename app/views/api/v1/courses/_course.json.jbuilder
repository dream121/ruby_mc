json.id course.id
json.title course.title
json.overview course.overview
json.skill course.skill
json.banner_image_url course.image_url
json.show_url course_url(course)
json.reviews_url course_reviews_url(course)
json.enrolled_url enrolled_course_url(course)
json.instructor_name course.instructor_name
json.instructor_first_name course.instructor_first_name
json.chapter_count course.chapter_count

user_course = current_user.user_courses.find_by(course_id: course.id).try(:decorate)
if user_course.present?
  state = 'enrolled'
  state = 'completed' if course.completed_by_user(current_user)
  state = 'reviewed' if course.completed_by_user(current_user) && course.reviewed_by_user(current_user)

  json.state state
  json.completed_chapter_count user_course.chapters_completed.count

  up_next = course.up_next(current_user)
  if up_next
    json.next_chapter_number course.up_next(current_user).number
    json.next_chapter_title course.up_next(current_user).title
  end

  latest_review = user_course.latest_review
  if latest_review
    json.latest_review latest_review, :id, :rating, :review
  end
end
