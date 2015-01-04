class ExperimentValuesController < ApplicationController
  before_filter :require_login
  before_action :set_experiment_value, only: [:edit, :update, :destroy]
  before_action :set_admin
  after_filter :verify_authorized

  def index
    authorize(ExperimentValue)
    @experiment_values = ExperimentValue.all
  end

  def new
    @experiment_value = ExperimentValue.new
    authorize(@experiment_value)
  end

  def edit
  end

  def create
    @experiment_value = ExperimentValue.new(experiment_value_params)
    authorize(@experiment_value)

    if @experiment_value.save
      redirect_to experiment_values_path, notice: 'Test value was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @experiment_value.update(experiment_value_params)
      redirect_to experiment_values_path, notice: 'Test value was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @experiment_value.destroy
    redirect_to experiment_values_url, notice: 'Test value was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experiment_value
      @experiment_value = ExperimentValue.find(params[:id])
      authorize(@experiment_value)
    end

    # Only allow a trusted parameter "white list" through.
    def experiment_value_params
      params.require(:experiment_value).permit(:experiment, :variation, :key, :value)
    end
end
