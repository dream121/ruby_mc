require 'spec_helper'

describe CoursesController do

  # This should return the minimal set of attributes required to create a valid
  # Course. As you add validations to Course, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :course
  end

  def other_valid_attributes
    valid_attributes.tap do |a|
      a[:title] = 'Another Course'
      a[:slug] = 'another-course'
    end
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CoursesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before do
    # TODO Set to :user and specify authorization rules in Ability.rb.
    # login_user build :admin
  end

  context 'for a non-logged-in user' do
    describe "#index" do
      it "assigns all courses as @courses" do
        course = Course.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:courses)).to eq([course])
      end
    end

    describe "#show" do
      it "assigns the requested course as @course" do
        course = Course.create! valid_attributes
        get :show, { :id => course.to_param }, valid_session
        expect(assigns(:course)).to eq(course)
      end

      context "when Accept header is 'application/text'" do
        before do
          request.headers["Accept"] = "application/text"
        end

        it "does not raise an ActionView::MissingTemplate exception" do
          course = Course.create! valid_attributes
          get :show, { :id => course.to_param }, valid_session
          expect(response).to render_template("show")
        end
      end
    end

    describe "#index_enrolled" do
      it "redirects me to sign-in" do
        get :index_enrolled, {}, valid_session
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  context 'for a logged-in user' do
    before do
      user_course = create(:user_course)
      sign_in user_course.user
      @mine = user_course.course
      @not_mine = Course.create! other_valid_attributes
    end

    describe "#index" do
      it "assigns all courses as @courses" do
        get :index, {}, valid_session
        expect(assigns(:courses)).to eq([@mine, @not_mine])
      end
    end

    describe "#index_enrolled" do
      it "shows me a list of my purchased courses" do
        get :index_enrolled, {}, valid_session
        expect(assigns(:courses)).to eq([@mine])
      end
    end

    describe "#show_enrolled" do
      it "assigns the requested course as @course" do
        get :show_enrolled, { :id => @mine.to_param }, valid_session
        expect(assigns(:course)).to eq(@mine)
        expect(assigns(:message)).to be_a(Message)
      end
    end
  end

  context 'for an admin user' do
    before do
      sign_in build :admin
    end

    describe "#new" do
      it "assigns a new course as @course" do
        get :new, {}, valid_session
        expect(assigns(:course)).to be_a_new(Course)
      end
    end

    describe "#edit" do
      it "assigns the requested course as @course" do
        course = Course.create! valid_attributes
        get :edit, { :id => course.to_param }, valid_session
        expect(assigns(:course)).to eq(course)
      end
    end

    describe "#create" do
      describe "with valid params" do
        it "creates a new Course" do
          expect {
            post :create, { :course => valid_attributes }, valid_session
          }.to change(Course, :count).by(1)
        end

        it "assigns a newly created course as @course" do
          post :create, {:course => valid_attributes }, valid_session
          expect(assigns(:course)).to be_a(Course)
          expect(assigns(:course)).to be_persisted
        end

        it "sets the slug if user left it blank" do
          attrs = valid_attributes.tap { |attrs| attrs[:slug] = '' }
          post :create, { :course => attrs }, valid_session
          expect(assigns(:course).slug).to match(/baking-bread/)
        end

        it "allows the user to set the slug" do
          attrs = valid_attributes.tap { |attrs| attrs[:slug] = 'my-slug' }
          post :create, { :course => attrs }, valid_session
          expect(assigns(:course).slug).to eq('my-slug')
        end

        it "redirects to the created course" do
          post :create, { :course => valid_attributes }, valid_session
          expect(response).to redirect_to(Course.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved course as @course" do
          # Trigger the behavior that occurs when invalid params are submitted
          Course.any_instance.stub(:save).and_return(false)
          post :create, { :course => { "title" => "invalid value" } }, valid_session
          expect(assigns(:course)).to be_a_new(Course)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Course.any_instance.stub(:save).and_return(false)
          post :create, { :course => { "title" => "invalid value" } }, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "#update" do
      describe "with valid params" do
        it "updates the requested course" do
          course = Course.create! valid_attributes
          # Assuming there are no other courses in the database, this
          # specifies that the Course created on the previous line
          # receives the :update message with whatever params are submitted in
          # the request.
          Course.any_instance.should_receive(:update).with({ "title" => "MyString" })
          put :update, { :id => course.to_param, :course => { "title" => "MyString" } }, valid_session
        end

        it "assigns the requested course as @course" do
          course = Course.create! valid_attributes
          put :update, { :id => course.to_param, :course => valid_attributes }, valid_session
          expect(assigns(:course)).to eq(course)
        end

        it "redirects to the course" do
          attrs = valid_attributes.tap{ |attrs| attrs.delete(:slug) }
          course = Course.create! attrs
          put :update, { :id => course.to_param, :course => attrs }, valid_session
          expect(response).to redirect_to(edit_course_path(course))
        end
      end

      describe "with invalid params" do
        it "assigns the course as @course" do
          course = Course.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Course.any_instance.stub(:save).and_return(false)
          put :update, { :id => course.to_param, :course => { "title" => "invalid value" } }, valid_session
          expect(assigns(:course)).to eq(course)
        end

        it "re-renders the 'edit' template" do
          course = Course.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Course.any_instance.stub(:save).and_return(false)
          put :update, { :id => course.to_param, :course => { "title" => "invalid value" } }, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "#destroy" do
      it "destroys the requested course" do
        course = Course.create! valid_attributes
        expect {
          delete :destroy, { :id => course.to_param }, valid_session
        }.to change(Course, :count).by(-1)
      end

      it "redirects to the courses list" do
        course = Course.create! valid_attributes
        delete :destroy, { :id => course.to_param }, valid_session
        expect(response).to redirect_to(courses_url)
      end
    end
  end
end
