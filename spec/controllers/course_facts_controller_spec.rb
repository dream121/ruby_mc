require 'spec_helper'

describe CourseFactsController do

  # This should return the minimal set of attributes required to create a valid
  # CourseFact. As you add validations to CourseFact, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :course_fact
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CourseFactsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before do
    # TODO Set to :user and specify authorization rules in Ability.rb.
    # login_user build :admin
  end

  let(:course) { create :course }
  let(:course_fact) { course.facts.create! valid_attributes }

  context "for an admin" do
    before do
      sign_in build :admin
    end

    describe "#new" do
      it "assigns a new course_fact as @course_fact" do
        course
        get :new, { :course_id => course.to_param }, valid_session
        expect(assigns(:course_fact)).to be_a_new(CourseFact)
      end
    end

    describe "#edit" do
      it "assigns the requested course_fact as @course_fact" do
        course_fact
        get :edit, { :course_id => course.to_param, :id => course_fact.to_param }, valid_session
        expect(assigns(:course_fact)).to eq(course_fact)
      end
    end

    describe "#create" do
      describe "with valid params" do
        it "creates a new CourseFact" do
          expect {
            post :create, { :course_id => course.to_param, :course_fact => valid_attributes }, valid_session
          }.to change(CourseFact, :count).by(1)
        end

        it "assigns a newly created course_fact as @course_fact" do
          post :create, { :course_id => course.to_param, :course_fact => valid_attributes }, valid_session
          expect(assigns(:course_fact)).to be_a(CourseFact)
          expect(assigns(:course_fact)).to be_persisted
        end

        it "redirects to the course/edit" do
          post :create, { :course_id => course.to_param,  :course_fact => valid_attributes }, valid_session
          expect(response).to redirect_to(edit_course_path(course))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved course_fact as @course_fact" do
          # Trigger the behavior that occurs when invalid params are submitted
          CourseFact.any_instance.stub(:save).and_return(false)
          post :create, { :course_id => course.to_param, :course_fact => { "course" => "invalid value" } }, valid_session
          expect(assigns(:course_fact)).to be_a_new(CourseFact)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CourseFact.any_instance.stub(:save).and_return(false)
          post :create, { :course_id => course.to_param, :course_fact => { "course" => "invalid value" } }, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "#update" do
      describe "with valid params" do
        it "updates the requested course_fact" do
          course_fact
          # Assuming there are no other course_facts in the database, this
          # specifies that the CourseFact created on the previous line
          # receives the :update message with whatever params are submitted in
          # the request.
          CourseFact.any_instance.should_receive(:update).with({ "position" => "3" })
          put :update, {  :course_id => course.to_param, :id => course_fact.to_param, :course_fact => { "position" => "3" } }, valid_session
        end

        it "assigns the requested course_fact as @course_fact" do
          course_fact
          put :update, {  :course_id => course.to_param, :id => course_fact.to_param, :course_fact => valid_attributes }, valid_session
          expect(assigns(:course_fact)).to eq(course_fact)
        end

        it "redirects to the course/edit" do
          course_fact
          put :update, { :course_id => course.to_param, :id => course_fact.to_param, :course_fact => valid_attributes }, valid_session
          expect(response).to redirect_to(edit_course_path(course))
        end
      end

      describe "with invalid params" do
        it "assigns the course_fact as @course_fact" do
          course_fact
          # Trigger the behavior that occurs when invalid params are submitted
          CourseFact.any_instance.stub(:save).and_return(false)
          put :update, { :course_id => course.to_param, :id => course_fact.to_param, :course_fact => { "course" => "invalid value" } }, valid_session
          expect(assigns(:course_fact)).to eq(course_fact)
        end

        it "re-renders the 'edit' template" do
          course_fact
          # Trigger the behavior that occurs when invalid params are submitted
          CourseFact.any_instance.stub(:save).and_return(false)
          put :update, { :course_id => course.to_param, :id => course_fact.to_param, :course_fact => { "course" => "invalid value" } }, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "#destroy" do
      it "destroys the requested course_fact" do
        course_fact
        expect {
          delete :destroy, { :course_id => course.to_param, :id => course_fact.to_param }, valid_session
        }.to change(CourseFact, :count).by(-1)
      end

      it "redirects to the course_facts list" do
        course_fact
        delete :destroy, { :course_id => course.to_param, :id => course_fact.to_param }, valid_session
        expect(response).to redirect_to(course_facts_url)
      end
    end
  end
end
