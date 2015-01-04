class CoursesController < ApplicationController
  before_filter :require_login, except: [:show, :index]
  before_filter :require_login_if_production
  before_filter :set_requested_path, only: [:show, :index]
  before_filter :find_course, only: [:office_hours]
  before_action :set_course, only: [:show, :show_enrolled, :edit, :update, :destroy]
  before_action :set_admin, only: [:edit, :new]
  after_filter :verify_authorized, only: [:show, :create, :edit, :update, :destroy]

  include SlugsHelper

  def show
    # optimizely:
    response.headers['X-Frame-Options'] = ''
    # TODO make cache methods for these instance variables
    @course = @course.decorate
    @product = Product.for_course(@course)
    @other_courses = Course.where('id != ?', @course.id).limit(3).decorate
    @core_skills = @course.facts.core_skills.order('position asc') if @course.facts
    @reviews = @course.reviews.where(featured: true).order('position asc').limit(4)
    track_event 'courses.marketing.show', course: @course.title
  end

  #TODO Refactor out into one show action. This logic should be
  # handled by the decorator and pundit. We should be avoiding adding
  # custom actions
  # Also keep all the database calls in the controller
  # Will make excessive DB calls obvious

  def show_enrolled
    @course = @course.decorate
    @chapters = @course.chapters.count
    @user_course = current_user_course(@course)
    @message = Message.new
    # @comments = CourseComment.for_course(@course).order(:position)
    track_event 'courses.enrolled.show', course: @course.title

    # optimizely:
    response.headers['X-Frame-Options'] = ''
    @revenue = session.delete(:revenue)
    @answer_count = @course.questions.where(visibility: true).count

    render :show_enrolled, :layout => "layouts/courses_enrolled"
  end

  def new
    @course = Course.new
    authorize(@course)
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    authorize(@course)

    if @course.save
      @course.create_product! name: @course.title, kind: 'course', price: 10000
      @course.create_detail
      update_slug(@course, course_params[:slug])
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @course.update(course_params)
      update_slug(@course, course_params[:slug])
      redirect_to edit_course_path(@course.to_param), notice: 'Course was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_url, notice: 'Course was successfully destroyed.'
  end

  def office_hours
    @questions = @course.questions.where(visibility: true).order(:position).limit(2)
    count = @questions.count
    @showing_all = (count == @questions.size)
    @question  = @course.questions.new
  end

  private

  def require_login_if_production
    require_login if Rails.env.production?
  end

  def set_course
    @course = Course.friendly.find(params[:id]).decorate
    @model = @course
    authorize(@course)
  end

  def find_course
    @course = Course.friendly.find(params[:course_id])
    # authorize(@course)
  end

  def course_params
    course_attributes = [:title, :category, :price, :start_date, :slug, :available_now, :review_average_display, :student_count_display]
    detail_marketing_attributes = [:headline, :role, :skill, :overview, :total_video_duration, :short_description, :intro_video_id, :featured_review, :tweet_text]
    detail_enrolled_attributes = [:lessons_introduction, :instructor_motivation, :welcome_statement, :welcome_back_statement]
    detail_attributes = [detail_marketing_attributes, detail_enrolled_attributes].flatten
    p = params.require(:course).permit(*course_attributes, { :instructor_ids => [] }, { detail_attributes: detail_attributes } )
    if p[:slug] && p[:slug].blank?
      p.delete(:slug)
    end
    p
  end
end
