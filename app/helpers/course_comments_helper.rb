module CourseCommentsHelper
  COMMENT_MAX_DEPTH = 3

  def comment_user_columns(comment)
    offset = comment.depth - 2
    offset = (COMMENT_MAX_DEPTH - 2) if (comment.depth > COMMENT_MAX_DEPTH)
    "col-sm-1 col-sm-offset-#{offset} col-xs-2 col-xs-offset-0"
  end

  def comment_details_columns(comment)
    columns = 13 - comment.depth
    columns = (13 - COMMENT_MAX_DEPTH) if (comment.depth > COMMENT_MAX_DEPTH)
    "col-sm-#{columns} col-xs-10"
  end

  def comment_user_type(user, course)
    if user.instructor?(course)
      'instructor'
    elsif user.admin?
      'staff'
    else
      nil
    end
  end

  
end
