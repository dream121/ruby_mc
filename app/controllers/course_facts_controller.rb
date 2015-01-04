class CourseFactsController < ApplicationController
  before_action :set_course
  before_action :set_course_fact, only: [:show, :edit, :update, :destroy]
  before_action :set_admin
  after_filter :verify_authorized

  def show
    authorize(@course_fact)
  end

  def new
    @course_fact = @course.facts.build(kind: params[:kind]).decorate
    authorize(@course_fact)
  end

  def edit
    authorize(@course_fact)
  end

  def create
    @course_fact = @course.facts.build(course_fact_params)
    authorize(@course_fact)

    if @course_fact.save
      redirect_to edit_course_path(@course), notice: 'Course fact was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    authorize(@course_fact)
    if @course_fact.update(course_fact_params)
      redirect_to edit_course_path(@course), notice: 'Course fact was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize(@course_fact)
    @course_fact.destroy
    redirect_to course_facts_url, notice: 'Course fact was successfully destroyed.'
  end

  private

  def set_course_fact
    @course_fact = @course.facts.find(params[:id]).decorate
  end

  def set_course
    @course = Course.friendly.find(params[:course_id]).decorate
  end

  # Only allow a trusted parameter "white list" through.
  def course_fact_params
    params.require(:course_fact).permit(:kind, :position, :icon, :number, :title, :description)
  end
end
