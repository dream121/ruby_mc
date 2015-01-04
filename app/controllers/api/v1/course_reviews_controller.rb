class Api::V1::CourseReviewsController < Api::V1::BaseController
  before_action :set_course, except: :index
  before_action :set_review, only: [:show, :update, :destroy]

  def create
    @review = @course.reviews.build(course_review_params)
    authorize(@review)
    @review.user = current_user
    if @review.save
      render template: 'api/v1/course_reviews/create.json.rabl'
    else
      render json: @review.errors
    end
  end

  def show
  end

  def update
    authorize(@review)
    if @review.update(course_review_params)
      render json: @review
    else
      render json: @review.errors
    end
  end

  private
    def course_review_params
      if current_user.admin?
        params.require(:course_review).permit(:review, :rating, :visible, :featured, :position)
      else
        params.require(:course_review).permit(:review, :rating)
      end
    end

    def set_review
      @review = CourseReview.find(params[:id])
    end

    def set_course
      @course = Course.friendly.find(params[:course_review][:course_id]).decorate
    end
end
