object @review => :course_review
attributes :id, :review, :rating, :course_id, :user_id,
           :visible, :featured, :position, :created_at, :updated_at

node(:edit_action_url) { |course_review| api_v1_course_review_path(course_review.id) }
