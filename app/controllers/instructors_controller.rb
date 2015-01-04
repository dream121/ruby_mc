class InstructorsController < ApplicationController
  before_filter :require_login
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  before_action :set_admin
  after_filter :verify_authorized

  include SlugsHelper

  def index
    @instructors = Instructor.all
    authorize(Instructor)
  end

  def show
    @course = @instructor.courses.first.decorate
    @other_courses = Course.where('id != ?', @course.id).limit(3).decorate
    @question = Question.find(@instructor.question_id).decorate if has_question?

    render template: 'instructors/show', layout: 'instructor'
  end

  def new
    @instructor = Instructor.new
    authorize(@instructor)
  end

  def edit
    @course = @instructor.courses.first.decorate
  end

  def create
    @instructor = Instructor.new(instructor_params)
    authorize(@instructor)

    if @instructor.save
      update_slug(@instructor, instructor_params[:slug])
      redirect_to @instructor, notice: 'Instructor was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @instructor.update(instructor_params)
      update_slug(@instructor, instructor_params[:slug])
      redirect_to @instructor, notice: 'Instructor was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @instructor.destroy
    redirect_to instructors_url, notice: 'Instructor was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      @instructor = Instructor.friendly.find(params[:id])
      authorize(@instructor)
    end

    def has_question?
      @instructor.question_id
    end

    # Only allow a trusted parameter "white list" through.
    def instructor_params
      params.require(:instructor).permit(:name, :short_bio, :long_bio, :email,
        :testimonials, :pitch_description, :popular_quote, :class_quote,
        :class_quote_attribution, :office_hours_pitch, :question_id,
        :hero_url, :popular_quote_logo_url)
    end
end
