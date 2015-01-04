class AnswersController < ApplicationController

  def new
    @answer = Answer.new
    @question = Question.find_by id: params[:question_id]
  end

  def create
    @answer = Answer.new answer_params
    @course = Course.friendly.find(course_params[:id])

    if @answer.save
      flash[:success] = "Answer successfully submitted!"
    else
      flash[:error] = "Answer submission failed."
    end

    redirect_to admin_index_course_office_hours_path(@course)

  end

  private 
    def answer_params
      params.require(:answer).permit!
    end

    def course_params
      params.require(:course).permit!
    end

end
