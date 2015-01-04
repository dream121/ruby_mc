json.comment do
  json.partial! 'api/v1/course_comments/comment', comment: @comment
end
