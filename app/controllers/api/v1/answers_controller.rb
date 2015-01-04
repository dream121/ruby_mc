class Api::V1::AnswersController < Api::V1::BaseController
  skip_after_filter :verify_authorized

  def create
  end

  def update
  end

  def show
    @answer = Answer.where(question_id: answer_params[:question_id])
    render template: 'api/v1/answers/show', status: 200
  end

  private
    def answer_params
      params.require(:answer).permit!
    end

end
