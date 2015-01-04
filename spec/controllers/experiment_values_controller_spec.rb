require 'spec_helper'

describe ExperimentValuesController do

  # This should return the minimal set of attributes required to create a valid
  # ExperimentValue. As you add validations to ExperimentValue, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :experiment_value
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ExperimentValuesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before do
    sign_in build :admin
  end

  describe "#index" do
    it "assigns all experiment_values as @experiment_values" do
      experiment_value = ExperimentValue.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:experiment_values)).to eq([experiment_value])
    end
  end

  describe "#new" do
    it "assigns a new experiment_value as @experiment_value" do
      get :new, {}, valid_session
      expect(assigns(:experiment_value)).to be_a_new(ExperimentValue)
    end
  end

  describe "#edit" do
    it "assigns the requested experiment_value as @experiment_value" do
      experiment_value = ExperimentValue.create! valid_attributes
      get :edit, { :id => experiment_value.to_param }, valid_session
      expect(assigns(:experiment_value)).to eq(experiment_value)
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new ExperimentValue" do
        expect {
          post :create, { :experiment_value => valid_attributes }, valid_session
        }.to change(ExperimentValue, :count).by(1)
      end

      it "assigns a newly created experiment_value as @experiment_value" do
        post :create, {:experiment_value => valid_attributes }, valid_session
        expect(assigns(:experiment_value)).to be_a(ExperimentValue)
        expect(assigns(:experiment_value)).to be_persisted
      end

      it "redirects to the created experiment_value" do
        post :create, { :experiment_value => valid_attributes }, valid_session
        expect(response).to redirect_to(experiment_values_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved experiment_value as @experiment_value" do
        # Trigger the behavior that occurs when invalid params are submitted
        ExperimentValue.any_instance.stub(:save).and_return(false)
        post :create, { :experiment_value => { "experiment" => "invalid value" } }, valid_session
        expect(assigns(:experiment_value)).to be_a_new(ExperimentValue)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ExperimentValue.any_instance.stub(:save).and_return(false)
        post :create, { :experiment_value => { "experiment" => "invalid value" } }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested experiment_value" do
        experiment_value = ExperimentValue.create! valid_attributes
        # Assuming there are no other experiment_values in the database, this
        # specifies that the ExperimentValue created on the previous line
        # receives the :update message with whatever params are submitted in
        # the request.
        ExperimentValue.any_instance.should_receive(:update).with({ "experiment" => "MyString" })
        put :update, { :id => experiment_value.to_param, :experiment_value => { "experiment" => "MyString" } }, valid_session
      end

      it "assigns the requested experiment_value as @experiment_value" do
        experiment_value = ExperimentValue.create! valid_attributes
        put :update, { :id => experiment_value.to_param, :experiment_value => valid_attributes }, valid_session
        expect(assigns(:experiment_value)).to eq(experiment_value)
      end

      it "redirects to the experiment_value" do
        experiment_value = ExperimentValue.create! valid_attributes
        put :update, { :id => experiment_value.to_param, :experiment_value => valid_attributes }, valid_session
        expect(response).to redirect_to(experiment_values_path)
      end
    end

    describe "with invalid params" do
      it "assigns the experiment_value as @experiment_value" do
        experiment_value = ExperimentValue.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ExperimentValue.any_instance.stub(:save).and_return(false)
        put :update, { :id => experiment_value.to_param, :experiment_value => { "experiment" => "invalid value" } }, valid_session
        expect(assigns(:experiment_value)).to eq(experiment_value)
      end

      it "re-renders the 'edit' template" do
        experiment_value = ExperimentValue.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ExperimentValue.any_instance.stub(:save).and_return(false)
        put :update, { :id => experiment_value.to_param, :experiment_value => { "experiment" => "invalid value" } }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested experiment_value" do
      experiment_value = ExperimentValue.create! valid_attributes
      expect {
        delete :destroy, { :id => experiment_value.to_param }, valid_session
      }.to change(ExperimentValue, :count).by(-1)
    end

    it "redirects to the experiment_values list" do
      experiment_value = ExperimentValue.create! valid_attributes
      delete :destroy, { :id => experiment_value.to_param }, valid_session
      expect(response).to redirect_to(experiment_values_url)
    end
  end

end
