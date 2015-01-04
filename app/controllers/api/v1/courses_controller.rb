class Api::V1::CoursesController < Api::V1::BaseController
  skip_after_action :verify_authorized, only: [:index, :recommended, :upcoming]
  after_action :verify_policy_scoped, only: [:index, :recommended, :upcoming]

  def index
    @courses = policy_scope(current_user.courses).decorate
    render template: 'api/v1/courses/collection'
  end

  def upcoming
    @courses = policy_scope(Course.coming).decorate
    render template: 'api/v1/courses/collection'
  end

  def recommended
    @courses = policy_scope(Course.recommended_for_user(current_user)).decorate
    render template: 'api/v1/courses/collection'
  end
end
