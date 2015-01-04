require 'spec_helper'

describe RecommendationsController do

  # This should return the minimal set of attributes required to create a valid
  # Recommendation. As you add validations to Recommendation, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :recommendation
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RecommendationsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  let(:product) { create :course_product }
  let(:related_product) { create :book_product }
  let(:recommendation) { create :recommendation, product_id: product.id, related_product_id: related_product.id }

  context "for an admin" do
    before do
      sign_in build :admin
    end

    describe "#new" do
      it "assigns a new recommendation as @recommendation" do
        get :new, { product_id: product.to_param }, valid_session
        expect(assigns(:recommendation)).to be_a_new(Recommendation)
      end
    end

    describe "#edit" do
      before do
        recommendation
      end

      it "assigns the requested recommendation as @recommendation" do
        get :edit, { product_id: recommendation.product_id, id: recommendation.to_param }, valid_session
        expect(assigns(:recommendation)).to eq(recommendation)
      end
    end

    describe "#create" do

      before do
        product
      end

      describe "with valid params" do
        it "creates a new Recommendation" do
          expect {
            post :create, { product_id: product.to_param, recommendation: valid_attributes }, valid_session
          }.to change(Recommendation, :count).by(1)
        end

        it "assigns a newly created recommendation as @recommendation" do
          post :create, { product_id: product.to_param, recommendation: valid_attributes }, valid_session
          expect(assigns(:recommendation)).to be_a(Recommendation)
          expect(assigns(:recommendation)).to be_persisted
        end

        it "redirects to the created recommendation" do
          post :create, { product_id: product.to_param, recommendation: valid_attributes }, valid_session
          expect(response).to redirect_to(product)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved recommendation as @recommendation" do
          # Trigger the behavior that occurs when invalid params are submitted
          Recommendation.any_instance.stub(:save).and_return(false)
          post :create, { product_id: product.to_param, recommendation: { "position" => "invalid value" } }, valid_session
          expect(assigns(:recommendation)).to be_a_new(Recommendation)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Recommendation.any_instance.stub(:save).and_return(false)
          post :create, { product_id: product.to_param, recommendation: { "position" => "invalid value" } }, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "#update" do
      before do
        recommendation
      end

      describe "with valid params" do
        it "updates the requested recommendation" do
          Recommendation.any_instance.should_receive(:update).with({ "position" => "1" })
          put :update, { product_id: recommendation.product_id, id: recommendation.to_param, recommendation: { "position" => "1" } }, valid_session
        end

        it "assigns the requested recommendation as @recommendation" do
          put :update, { product_id: recommendation.product_id, id: recommendation.to_param, recommendation: valid_attributes }, valid_session
          expect(assigns(:recommendation)).to eq(recommendation)
        end

        it "redirects to the product" do
          put :update, { product_id: recommendation.product_id, id: recommendation.to_param, recommendation: valid_attributes }, valid_session
          expect(response).to redirect_to(recommendation.product)
        end
      end

      describe "with invalid params" do
        it "assigns the recommendation as @recommendation" do
          Recommendation.any_instance.stub(:save).and_return(false)
          put :update, { product_id: recommendation.product_id, id: recommendation.to_param, recommendation: valid_attributes }, valid_session
          expect(assigns(:recommendation)).to eq(recommendation)
        end

        it "re-renders the 'edit' template" do
          Recommendation.any_instance.stub(:save).and_return(false)
          put :update, { product_id: recommendation.product_id, id: recommendation.to_param, recommendation: valid_attributes }, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "#destroy" do
      before do
        recommendation
      end

      it "destroys the requested recommendation" do
        expect {
          delete :destroy, { product_id: recommendation.product_id, id: recommendation.to_param }, valid_session
        }.to change(Recommendation, :count).by(-1)
      end

      it "redirects to the product" do
        delete :destroy, { product_id: recommendation.product_id, id: recommendation.to_param }, valid_session
        expect(response).to redirect_to(recommendation.product)
      end
    end

  end
end
