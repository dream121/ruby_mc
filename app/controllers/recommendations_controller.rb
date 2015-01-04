class RecommendationsController < ApplicationController
  before_action :set_product
  before_action :set_admin
  after_filter :verify_authorized
  before_action :set_recommendation, only: [:show, :edit, :update, :destroy]

  def new
    @recommendation = @product.recommendations.build
    authorize(@recommendation)
  end

  def edit
    authorize(@recommendation)
  end

  def create
    @recommendation = @product.recommendations.build(recommendation_params)
    authorize(@recommendation)

    if @recommendation.save
      redirect_to @product, notice: 'Recommendation was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    authorize(@recommendation)
    if @recommendation.update(recommendation_params)
      redirect_to @product, notice: 'Recommendation was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize(@recommendation)
    @recommendation.destroy
    redirect_to @product, notice: 'Recommendation was successfully destroyed.'
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def recommendation_params
    params.require(:recommendation).permit(:position, :related_product_id)
  end
end
