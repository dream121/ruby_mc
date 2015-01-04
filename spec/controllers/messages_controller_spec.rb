require 'spec_helper'

describe MessagesController do

  # This should return the minimal set of attributes required to create a valid
  # Message. As you add validations to Message, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :message
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MessagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  let(:user_course) { create :user_course }
  let(:instructor) { create :instructor }
  let(:course) { user_course.course }
  let(:user) { user_course.user }

  before do
    sign_in user
    course.instructors << instructor
  end

  describe "#create" do
    describe "with valid params" do
      it "assigns a newly created message as @message" do
        post :create, { course_id: course.id, :message => valid_attributes }, valid_session
        expect(assigns(:message)).to be_a(Message)
      end

      it "redirects to the enrolled course" do
        post :create, { course_id: course.id, :message => valid_attributes }, valid_session
        expect(response).to redirect_to(enrolled_course_path(course))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved message as @message" do
        # Trigger the behavior that occurs when invalid params are submitted
        Message.any_instance.stub(:valid?).and_return(false)
        post :create, { course_id: course.id, :message => { 'foo' => 'bar' } }, valid_session
        expect(assigns(:message)).to be_a(Message)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Message.any_instance.stub(:valid?).and_return(false)
        post :create, { course_id: course.id, :message => { 'foo' => 'bar' } }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

end
