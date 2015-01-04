class Api::V1::QuestionsController < Api::V1::BaseController
  skip_after_filter :verify_authorized
  def index
    if params[:results_only] == true
    else
      set_search_result_vars(Question.search(params))
    end
    @results = @results.decorate
    render template: 'api/v1/questions/index.json.rabl'
  end


  def create
    @question = Question.new(question_params)
    if @question.save
      render template: 'api/v1/questions/show.json.rabl'
      # render template: 'api/v1/questions/index.json.rabl'
      # render @question
    else
      render @question.errors.to_json
    end
  end


  private
    def question_params
      params.require(:question).permit!
    end
end
