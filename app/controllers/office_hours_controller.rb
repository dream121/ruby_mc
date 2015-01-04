class OfficeHoursController < ApplicationController
  before_filter :require_login
  before_filter :find_course
  before_filter :find_question, only: [:update, :edit, :show, :destroy, :answer]
  before_filter :admin_body_class, only: [:admin_index, :edit, :show, :answer]

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    # Question.search(visibility: true, limit: 2, page: 1, per_page: 2, course_id: @course.id, results_only: true).decorate
    res             = Question.search(visibility: true, limit: 5, page: 1, per_page:5, course_id: @course.id)
    #binding.pry
    @questions      = res[:result_set].decorate
    @items_left     = res[:items_left]
    @total_items    = res[:total_items]
    @next_page_url  = res[:next_page_url]
    @question       = @course.questions.new
  end

  def admin_index
    authorize(Question.new)
    @questions = policy_scope(Question).includes(:answer, :user).where(course_id: @course.id).order(:position).decorate
  end

  def create
    @question = @course.questions.new(question_params)

    if @question.save
      flash[:success] = 'Question successfully submitted!'
      redirect_to course_office_hours_path
    else
      flash[:error] = 'Question submission failed'
      render :new
    end
  end

  def edit
    authorize(@question)
  end

  def show
  end

  def update
    authorize(@question)

    if @question.update_attributes(question_params)
      flash[:success] = 'Question successfully updated!'
      redirect_to admin_index_course_office_hours_path(@course)
    else
      flash[:error] = 'Question update failed'
      render :edit
    end
  end

  def destroy
    authorize(@question)
    @question.destroy

    redirect_to admin_index_course_office_hours_path(@course)
  end

  def answer
    authorize(@question)
    @answer = Answer.new
  end

  private
    def find_course
      @course = Course.friendly.find(params[:course_id])
    end

    def find_question
      @question = @course.questions.find(params[:id]).decorate
    end

    def question_params
      params.require(:question).permit!
    end

    def admin_body_class
      @body_class = 'admin'
    end

    def user_not_authorized(e)
      flash[:error] = "You are not authorized to perform this action."
      redirect_to course_office_hours_path(@course)
    end
end
