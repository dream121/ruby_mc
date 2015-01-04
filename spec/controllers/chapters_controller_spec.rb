require 'spec_helper'

describe ChaptersController do

  # This should return the minimal set of attributes required to create a valid
  # Chapter. As you add validations to Chapter, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for(:chapter)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChaptersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  let(:user_course) { create :user_course }
  let(:course) { user_course.course }
  let(:chapter) { course.chapters.create! valid_attributes }

  context "for a user" do
    before do
      sign_in user_course.user
    end

    describe "#show" do
      before do
        chapter
      end

      it "assigns the requested chapter as @chapter" do
        get :show, { :course_id => course.to_param, :id => chapter.to_param }, valid_session
        expect(assigns(:chapter)).to eq(chapter)
      end
    end

    describe "#watch" do
      before do
        chapter
        user_course.progress = { chapter.id => { "position" => 3.33, "duration" => 10.0 } }
        user_course.save!
      end

      it "assigns the requested chapter as @chapter" do
        get :watch, { :course_id => course.to_param, :id => chapter.to_param }, valid_session
        expect(assigns(:chapter)).to eq(chapter)
        expect(assigns(:chapter_position)).to eq(3.33)
      end
    end
  end

  context "for an admin" do
    before do
      sign_in build :admin
    end

    describe "#new" do
      it "assigns a new chapter as @chapter" do
        get :new, { :course_id => course.to_param }, valid_session
        expect(assigns(:chapter)).to be_a_new(Chapter)
      end
    end

    describe "#edit" do
      before do
        chapter
      end

      it "assigns the requested chapter as @chapter" do
        get :edit, { :course_id => course.to_param, :id => chapter.to_param }, valid_session
        expect(assigns(:chapter)).to eq(chapter)
      end
    end

    describe "#watch" do
      before do
        chapter
      end

      it "assigns the requested chapter as @chapter" do
        get :watch, { :course_id => course.to_param, :id => chapter.to_param }, valid_session
        expect(assigns(:chapter)).to eq(chapter)
        expect(assigns(:chapter_position)).to eq(0)
      end
    end

    describe "#create" do
      describe "with valid params" do
        it "creates a new Chapter" do
          expect {
            post :create, { :course_id => course.to_param, :chapter => valid_attributes }, valid_session
          }.to change(Chapter, :count).by(1)
        end

        it "assigns a newly created chapter as @chapter" do
          post :create, { :course_id => course.to_param, :chapter => valid_attributes }, valid_session
          expect(assigns(:chapter)).to be_a(Chapter)
          expect(assigns(:chapter)).to be_persisted
        end

        it "sets the slug if user left it blank" do
          attrs = valid_attributes.tap { |attrs| attrs[:slug] = '' }
          post :create, { :course_id => course.to_param, :chapter => attrs }, valid_session
          expect(assigns(:chapter).slug).to eq('chapter-one')
        end

        it "allows the user to set the slug" do
          attrs = valid_attributes.tap { |attrs| attrs[:slug] = 'my-slug' }
          post :create, { :course_id => course.to_param, :chapter => attrs }, valid_session
          expect(assigns(:chapter).slug).to eq('my-slug')
        end

        it "redirects to the course" do
          post :create, { :course_id => course.to_param, :chapter => valid_attributes }, valid_session
          expect(response).to redirect_to(course)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved chapter as @chapter" do
          # Trigger the behavior that occurs when invalid params are submitted
          Chapter.any_instance.stub(:save).and_return(false)
          post :create, { :course_id => course.to_param, :chapter => { "number" => "invalid value" } }, valid_session
          expect(assigns(:chapter)).to be_a_new(Chapter)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Chapter.any_instance.stub(:save).and_return(false)
          post :create, { :course_id => course.to_param, :chapter => { "number" => "invalid value" } }, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "#update" do
      before do
        chapter
      end

      describe "with valid params" do
        it "updates the requested chapter" do
          Chapter.any_instance.should_receive(:update).with({ "number" => "1" })
          put :update, { :course_id => course.to_param, :id => chapter.to_param, :chapter => { "number" => "1" } }, valid_session
        end

        it "assigns the requested chapter as @chapter" do
          put :update, { :course_id => course.to_param, :id => chapter.to_param, :chapter => valid_attributes }, valid_session
          expect(assigns(:chapter)).to eq(chapter)
        end

        it "redirects to the course" do
          put :update, { :course_id => course.to_param, :id => chapter.to_param, :chapter => valid_attributes }, valid_session
          expect(response).to redirect_to(course)
        end
      end

      describe "with invalid params" do
        it "assigns the chapter as @chapter" do
          Chapter.any_instance.stub(:save).and_return(false)
          put :update, { :course_id => course.to_param, :id => chapter.to_param, :chapter => { "number" => "invalid value" } }, valid_session
          expect(assigns(:chapter)).to eq(chapter)
        end

        it "re-renders the 'edit' template" do
          Chapter.any_instance.stub(:save).and_return(false)
          put :update, { :course_id => course.to_param, :id => chapter.to_param, :chapter => { "number" => "invalid value" } }, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "#destroy" do
      before do
        chapter
      end

      it "destroys the requested chapter" do
        expect {
          delete :destroy, { :course_id => course.to_param, :id => chapter.to_param }, valid_session
        }.to change(Chapter, :count).by(-1)
      end

      it "redirects to the course" do
        delete :destroy, { :course_id => course.to_param, :id => chapter.to_param }, valid_session
        expect(response).to redirect_to(course)
      end
    end
  end

end
