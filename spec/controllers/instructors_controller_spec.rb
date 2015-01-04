require 'spec_helper'

describe InstructorsController do

  # This should return the minimal set of attributes required to create a valid
  # Instructor. As you add validations to Instructor, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :instructor
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # InstructorsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  context "for a non-admin user" do
    before do
      sign_in build :user
    end

    describe "#edit" do
      it "redirects to the sign-in page" do
        instructor = Instructor.create! valid_attributes
        get :edit, { :id => instructor.to_param }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context "for an admin user" do

    before do
      sign_in build :admin
    end

    describe "#index" do
      it "assigns all instructors as @instructors" do
        instructor = Instructor.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:instructors)).to eq([instructor])
      end
    end

    describe "#show" do
      it "assigns the requested instructor as @instructor" do
        instructor = Instructor.create! valid_attributes
        get :show, { :id => instructor.to_param }, valid_session
        expect(assigns(:instructor)).to eq(instructor)
      end
    end

    describe "#new" do
      it "assigns a new instructor as @instructor" do
        get :new, {}, valid_session
        expect(assigns(:instructor)).to be_a_new(Instructor)
      end
    end

    describe "#edit" do
      it "assigns the requested instructor as @instructor" do
        instructor = Instructor.create! valid_attributes
        get :edit, { :id => instructor.to_param }, valid_session
        expect(assigns(:instructor)).to eq(instructor)
      end
    end

    describe "#create" do
      describe "with valid params" do
        it "creates a new Instructor" do
          expect {
            post :create, { :instructor => valid_attributes }, valid_session
          }.to change(Instructor, :count).by(1)
        end

        it "assigns a newly created instructor as @instructor" do
          post :create, {:instructor => valid_attributes }, valid_session
          expect(assigns(:instructor)).to be_a(Instructor)
          expect(assigns(:instructor)).to be_persisted
        end

        it "redirects to the created instructor" do
          post :create, { :instructor => valid_attributes }, valid_session
          expect(response).to redirect_to(Instructor.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved instructor as @instructor" do
          # Trigger the behavior that occurs when invalid params are submitted
          Instructor.any_instance.stub(:save).and_return(false)
          post :create, { :instructor => { "name" => "invalid value" } }, valid_session
          expect(assigns(:instructor)).to be_a_new(Instructor)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Instructor.any_instance.stub(:save).and_return(false)
          post :create, { :instructor => { "name" => "invalid value" } }, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "#update" do
      describe "with valid params" do
        it "updates the requested instructor" do
          instructor = Instructor.create! valid_attributes
          # Assuming there are no other instructors in the database, this
          # specifies that the Instructor created on the previous line
          # receives the :update message with whatever params are submitted in
          # the request.
          Instructor.any_instance.should_receive(:update).with({ "name" => "MyString" })
          put :update, { :id => instructor.to_param, :instructor => { "name" => "MyString" } }, valid_session
        end

        it "assigns the requested instructor as @instructor" do
          instructor = Instructor.create! valid_attributes
          put :update, { :id => instructor.to_param, :instructor => valid_attributes }, valid_session
          expect(assigns(:instructor)).to eq(instructor)
        end

        it "redirects to the instructor" do
          instructor = Instructor.create! valid_attributes
          put :update, { :id => instructor.to_param, :instructor => valid_attributes }, valid_session
          expect(response).to redirect_to(instructor)
        end
      end

      describe "with invalid params" do
        it "assigns the instructor as @instructor" do
          instructor = Instructor.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Instructor.any_instance.stub(:save).and_return(false)
          put :update, { :id => instructor.to_param, :instructor => { "name" => "invalid value" } }, valid_session
          expect(assigns(:instructor)).to eq(instructor)
        end

        it "re-renders the 'edit' template" do
          instructor = Instructor.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Instructor.any_instance.stub(:save).and_return(false)
          put :update, { :id => instructor.to_param, :instructor => { "name" => "invalid value" } }, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "#destroy" do
      it "destroys the requested instructor" do
        instructor = Instructor.create! valid_attributes
        expect {
          delete :destroy, { :id => instructor.to_param }, valid_session
        }.to change(Instructor, :count).by(-1)
      end

      it "redirects to the instructors list" do
        instructor = Instructor.create! valid_attributes
        delete :destroy, { :id => instructor.to_param }, valid_session
        expect(response).to redirect_to(instructors_url)
      end
    end
  end
end