require 'spec_helper'

describe Api::V1::UserCoursesController do

  let(:user_course) { create :user_course, progress: { "1" => { "position" => "1.23", "duration" => "30.0" } } }
  let(:other_user_course) { create :user_course, course: user_course.course, progress: { "foo" => "bar" } }

  def valid_session
    {}
  end

  before do
    sign_in user_course.user
  end

  describe "#update" do
    let(:progress_data) { {"chapter_id" => "5", "position" => "5.33", "duration" => "10.33" } }
    let(:expected) do
      {
        "5" => { "position" => "5.33", "duration" => "10.33" },
        "1" => { "position" => "1.23", "duration" => "30.0" }
      }
    end

    describe "with valid params" do
      let(:valid_params) do
        { user_id: user_course.user_id, id: user_course.id, user_course: { progress: progress_data } }
      end

      it "updates the requested user_course" do
        # UserCourse.any_instance.should_receive(:update).with({ "number" => "1" })
        put :update, valid_params, valid_session
        user_course.reload
        expect(user_course.progress).to eq(expected)
      end

      it "responds with success" do
        put :update, valid_params, valid_session
        expect(response).to be_success
      end
    end

    describe "with a course for a different user" do
      let(:invalid_params) do
        { user_id: other_user_course.user_id, id: other_user_course.id, user_course: { progress: progress_data } }
      end

      it "does not update the requested user_course" do
        # UserCourse.any_instance.should_receive(:update).with({ "number" => "1" })
        put :update, invalid_params, valid_session
        other_user_course.reload
        expect(other_user_course.progress).to eq( { "foo" => "bar" } )
      end

      it "responds with error" do
        put :update, invalid_params, valid_session
        expect(response.code).to eq("401")
      end
    end
  end
end
