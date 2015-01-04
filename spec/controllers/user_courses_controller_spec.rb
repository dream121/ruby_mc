require 'spec_helper'

describe UserCoursesController do

  def valid_attributes
    { "access" => true }
  end

  def valid_session
    {}
  end

  let(:user_course) { create :user_course }
  let(:user_course2) { create :user_course }

  before do
    sign_in build :admin
  end

  describe "#edit" do
    it "assigns the requested user_course as @user_course" do
      get :edit, { user_id: user_course.user_id, id: user_course.to_param }, valid_session
      expect(assigns(:user_course)).to eq(user_course)
    end
  end

  describe "#index" do
    it "assigns the course's user_courses as @user_courses" do
      get :index, { course_id: user_course.course.to_param }, valid_session
      expect(assigns(:user_courses)).to eq([user_course])
    end
  end

  describe "#prospects" do
    it "assigns the course's prospects as @users" do
      get :prospects, { course_id: user_course.course.to_param }, valid_session
      expect(assigns(:users)).to eq([user_course2.user])
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested user_course" do
        UserCourse.any_instance.should_receive(:update).with(valid_attributes)
        put :update, { user_id: user_course.user_id, id: user_course.to_param, user_course: valid_attributes }, valid_session
      end

      it "assigns the requested user_course as @user_course" do
        put :update, { user_id: user_course.user_id, id: user_course.to_param, user_course: valid_attributes }, valid_session
        expect(assigns(:user_course)).to eq(user_course)
      end

      it "redirects to the user" do
        put :update, { user_id: user_course.user_id, id: user_course.to_param, user_course: valid_attributes }, valid_session
        expect(response).to redirect_to(user_course.user)
      end
    end

    describe "with invalid params" do
      it "assigns the user_course as @user_course" do
        UserCourse.any_instance.stub(:save).and_return(false)
        put :update, { user_id: user_course.user_id, id: user_course.to_param, user_course: { "user" => "invalid value" } }, valid_session
        expect(assigns(:user_course)).to eq(user_course)
      end

      it "re-renders the 'edit' template" do
        UserCourse.any_instance.stub(:save).and_return(false)
        put :update, { user_id: user_course.user_id, id: user_course.to_param, user_course: { "user" => "invalid value" } }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end
end
