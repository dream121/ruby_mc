json.array!(@course_reviews) do |course_review|
  json.extract! course_review, :id, :review, :rating, :name, :location, :course_id, :user_id, :visible, :featured, :position
  json.url course_review_url(course_review, format: :json)
end
