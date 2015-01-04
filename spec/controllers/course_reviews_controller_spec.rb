require 'spec_helper'

describe CourseReviewsController do

  def valid_user_review_attributes
    { review: 'My Review', rating: 4, name: "Mr. Smith", location: 'NYC' }
  end

  def valid_admin_review_attributes
    { visible: 'true' }
  end

  def valid_session
    {}
  end

  let(:admin) { create :admin }
  let(:user_course) { create :user_course }
  let(:user) { user_course.user }
  let(:course) { user_course.course }
  let(:review) { course.reviews.create(review: "My Review", rating: 4, name: "Mr. Smith", location: 'NYC', user: user) }
  let(:course_b) { create :course }
  let(:review_b) { course_b.reviews.create(review: "Other Review", rating: 4, name: "Mr. Smith", location: 'NYC', user: user) }

  context "For an enrolled user" do
    before do
      sign_in user
    end

    describe "#index" do
      it "redirects" do
        get :index, { course_id: course.to_param }, valid_session
        expect(response.code).to eq("302")
      end
    end

    describe "#new" do
      it "assigns a new course_review as @course_review" do
        get :new, { course_id: course.to_param }, valid_session
        expect(assigns(:review)).to be_a_new(CourseReview)
      end
    end

    describe "#create" do
      let(:valid_params) do
        {
          course_id: course.to_param,
          course_review: valid_user_review_attributes
        }
      end

      describe "with valid params" do
        it "creates a new CourseReview" do
          expect {
            post :create, valid_params, valid_session
          }.to change(CourseReview, :count).by(1)
        end

        it "assigns a newly created course_review as @review" do
          post :create, valid_params, valid_session
          expect(assigns(:review)).to be_a(CourseReview)
          expect(assigns(:review)).to be_persisted
        end

        it "redirects to the course enrolled page" do
          post :create, valid_params, valid_session
          expect(response).to redirect_to(enrolled_course_path(course))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved course_review as @review" do
          CourseReview.any_instance.stub(:save).and_return(false)
          post :create, valid_params, valid_session
          expect(assigns(:review)).to be_a_new(CourseReview)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CourseReview.any_instance.stub(:save).and_return(false)
          post :create, valid_params, valid_session
          expect(response).to render_template("new")
        end
      end
    end
  end

  context "for an admin" do

    before do
      sign_in admin
    end

    describe "#index" do
      before do
        review
        review_b
      end

      context "for a course" do
        it "assigns reviews for this course to @reviews" do
          get :index, { course_id: course.to_param }, valid_session
          expect(assigns(:reviews).to_a).to eq([review])
        end
      end

      context "for all courses" do
        it "assigns all reviews to @reviews" do
          get :index, {}, valid_session
          expect(assigns(:reviews).to_a).to eq([review_b, review])
        end
      end
    end

    describe "#edit" do
      it "assigns the requested course_review as @review" do
        review
        get :edit, { course_id: course.to_param, id: review.to_param }, valid_session
        expect(assigns(:review)).to eq(review)
      end
    end

    describe "#update" do
      let(:valid_params) do
        { course_id: course.to_param, id: review.to_param, course_review: { 'visible' => true } }
      end

      describe "with valid params" do

        it "updates the requested course_review" do
          review
          CourseReview.any_instance.should_receive(:update).with({ 'visible' => true })
          put :update, valid_params, valid_session
        end

        it "assigns the requested course_review as @course_review" do
          review
          put :update, valid_params, valid_session
          expect(assigns(:review)).to eq(review)
        end

        it "redirects to the course_reviews index" do
          review
          put :update, valid_params, valid_session
          expect(response).to redirect_to(reviews_path)
        end
      end

      describe "with invalid params" do
        it "assigns the course_review as @course_review" do
          review
          CourseReview.any_instance.stub(:save).and_return(false)
          put :update, valid_params, valid_session
          expect(assigns(:review)).to eq(review)
        end

        it "re-renders the 'edit' template" do
          review
          CourseReview.any_instance.stub(:save).and_return(false)
          put :update, valid_params, valid_session
          expect(response).to render_template("edit")
        end
      end
    end
  end

end
