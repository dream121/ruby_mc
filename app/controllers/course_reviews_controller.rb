class CourseReviewsController < ApplicationController
  before_action :set_admin, only: [:edit, :index]
  before_action :set_course, except: :index
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  after_filter :verify_authorized

  def index
    authorize(CourseReview)
    if params[:course_id]
      set_course
      @reviews = @course.reviews.order('created_at DESC')
    else
      @reviews = CourseReview.all.order('created_at DESC')
    end
  end

  def new
    @review = @course.reviews.build(user: current_user)
    authorize(@review)
  end

  def edit
    authorize(@review)
  end

  def create
    @review = @course.reviews.build(course_review_params)
    authorize(@review)
    @review.user = current_user
    @review.name = current_user.name unless @review.name.present?
    @review.location = "default location" unless @review.location.present?

    if @review.save
      redirect_to enrolled_course_path(@course), notice: 'Thank you for your review. It will be approved and displayed shortly!'
    else
      render action: 'new'
    end
  end

  def update
    authorize(@review)
    if @review.update(course_review_params)
      redirect_to reviews_path, notice: 'Course review was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @review.destroy
    redirect_to course_reviews_url, notice: 'Course review was successfully destroyed.'
  end

  private

  def set_review
    @review = CourseReview.find(params[:id])
  end

  def course_review_params
    if current_user.admin?
      params.require(:course_review).permit(:review, :rating, :name, :location, :visible, :featured, :position)
    else
      params.require(:course_review).permit(:review, :rating, :name, :location)
    end
  end

  def set_course
    @course = Course.friendly.find(params[:course_id]).decorate
  end

end
