class QuestionsController < ApplicationController

  def create
    @question = Question.new question_params
    @course_id = params[:course_id]

    if @question.save
      flash[:success] = "Question successfully submitted!"
    else
      flash[:error] = "Question submission failed."
    end

    redirect_to course_office_hours_path(@course_id)
  end

  def update
    @question = Question.find params[:id]
    @question.update_attributes question_params

    if @question.valid?
      flash[:success] = "Question successfully submitted!"
    else
      flash[:error] = "Question submission failed."
    end

    redirect_to "/courses/#{@question.course_id}/office-hours/index"

  end

  def index
    questions = Question.where(visibility: true,course_id: params[:course_id]).order(:position)

    questions = remove_unnecessary_questions(questions, params[:last_id].to_i) if params[:last_id]

    course    = Course.find_by id: params[:course_id]
    done = (questions.last == Question.where(course_id: params[:course_id], visibility: true).order(:position).last)

    html = ""
    questions.each do |question|
      question = question.decorate
      html += render_to_string(:partial => 'courses/question_and_answer', :layout => false, :locals => {question: question, questions: questions})
      html = html.gsub(/\[#&lt;.*&gt;].*$/, "")
    end

    render json: { html: html, done: done }
  end

  def admin
    @course = Course.friendly.find(params[:id])
    @questions = @course.questions.order(:position)
  end

  def show
    @question = Question.find_by id: params[:id]
  end

  def edit
    @question = Question.find_by id: params[:id]
  end

  def destroy
    @question = Question.find_by id: params[:id]
    course_id = @question.course_id

    @question.destroy

    if @question.destroyed?
      flash[:success] = "Question removed."
    else
      flash[:warning] = "Could not remove question."
    end

    redirect_to "/courses/#{course_id}/office-hours/index"
  end


  private
    def question_params
      params.require(:question).permit!
    end

    def remove_unnecessary_questions(array, id)
      x = array.shift
      return array.to_a[0..4] if x.id == id
      return remove_unnecessary_questions(array, id)
    end

end
