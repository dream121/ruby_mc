module StudentsHelper
  def needs_separator? profile
    true if profile.city? || profile.country?
  end

  def total_courses
    profile.user.user_courses.count
  end

  def total_comments_by user
    CourseComment.total_by_user user
  end
end
