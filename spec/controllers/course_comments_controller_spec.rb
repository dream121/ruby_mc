require 'spec_helper'

describe CourseCommentsController do

  def valid_user_comment_attributes
    { comment: 'My Comment' }
  end

  def valid_user_comment_with_image_attributes
    { comment: 'My Comment' }.merge valid_attributes
  end

  def valid_admin_comment_attributes
    { visible: 'false' }
  end

  def valid_admin_topic_attributes
    { comment: 'Topic 1', position: 1 }
  end

  def valid_session
    {}
  end

  def valid_attributes
    attrs = attributes_for(:image).tap do |a|
      a[:image] = fixture_file_upload('spec/factories/images/rails.png', 'image/png')
    end
  end

  let(:admin) { create :admin }
  let(:user_course) { create :user_course }
  let(:user) { user_course.user }
  let(:course) { user_course.course }
  let(:topic) { course.comments.create(valid_admin_topic_attributes) }
  let(:comment) { course.comments.create(comment: "Hello World", parent: topic, user: user, visible: true) }

  before do
    stub_request(:head, %r{test\.s3\.amazonaws\.com}).to_return status: 404, body: ''
    stub_request(:put, %r{test\.s3\.amazonaws\.com}).to_return status: 201, body: ''
    sign_in build :admin
  end

  context "for a user" do
    before do
      topic
      sign_in user
    end

    describe "#show" do
      before do
        comment
      end

      it "assigns the requested comment as @comment" do
        get :show, { course_id: course.to_param, id: comment.to_param }, valid_session
        expect(assigns(:comment)).to eq(comment)
      end
    end

    describe "#create" do
      let(:valid_params) do
        {
          course_id: course.to_param,
          parent_id: topic.id,
          course_comment: valid_user_comment_attributes
        }
      end

      describe "with valid params" do
        it "creates a new comment" do
          expect {
            post :create, valid_params, valid_session
          }.to change(CourseComment, :count).by(1)
        end

        it "assigns a newly created comment as @comment" do
          post :create, valid_params, valid_session
          expect(assigns(:comment)).to be_a(CourseComment)
          expect(assigns(:comment)).to be_persisted
          expect(assigns(:comment).parent).to eq(topic)
        end

        it "creates an image for a course comment submitted with an image" do
          expect {
            post :create, { :course_id => course.to_param, :parent_id => topic.id, course_comment: valid_user_comment_with_image_attributes }, valid_session
          }.to change(CourseComment, :count).by(1)
          expect(assigns(:comment).image).to be_a(Image)
          expect(assigns(:comment).image).to be_persisted
        end

        # This test is for ajax comments
        # it "renders the comment partial" do
        #   post :create, valid_params, valid_session
        #   expect(response).to render_template('course_comments/_comment')
        # end
      end

      describe "with invalid params" do
        context "when comment can't be saved" do
          it "returns an error response" do
            # Trigger the behavior that occurs when invalid params are submitted
            CourseComment.any_instance.stub(:save).and_return(false)
            post :create, valid_params, valid_session
            expect(response).to be_error
          end
        end

        context "when parent_id is missing" do
          it "raises an error" do
            p = valid_params
            p.delete(:parent_id)
            expect { post :create, p, valid_session }.to raise_error(ActionController::ParameterMissing)
          end
        end
      end
    end

    describe "#update" do
      context "when attempting to moderate" do
        let(:valid_params) do
          {
            format: 'js',
            course_id: course.to_param,
            id: comment.to_param,
            course_comment: { visible: 'false' }
          }
        end

        it "does not update the comment" do
          put :update, valid_params, valid_session
          comment.reload
          expect(comment.visible).to be_true
        end
      end

      context "when attempting to edit a comment" do
        let(:valid_params) do
          {
            course_id: course.to_param,
            id: comment.to_param,
            course_comment: { comment: 'edited' }
          }
        end

        it "does not update the comment" do
          put :update, valid_params, valid_session
          comment.reload
          expect(comment.comment).to eq("Hello World")
        end
      end

      context "when voting on a comment" do
        let(:upvote_params) do
          {
            format: 'js',
            course_id: course.to_param,
            id: comment.to_param,
            course_comment: { vote: 'up' }
          }
        end

        let(:downvote_params) do
          {
            format: 'js',
            course_id: course.to_param,
            id: comment.to_param,
            course_comment: { vote: 'down' }
          }
        end

        context 'for an enrolled course' do
          it 'allows each user only one upvote' do
            put :update, upvote_params, valid_session
            comment.reload
            expect(comment.votes).to eq(1)
            expect(comment.voters['up']).to eq([user.id])
            expect(comment.voters['down']).to eq([])

            put :update, upvote_params, valid_session
            comment.reload
            expect(comment.votes).to eq(1)
            expect(comment.voters['up']).to eq([user.id])
            expect(comment.voters['down']).to eq([])
          end

          it 'allows each user to downvote to undo their upvote' do
            put :update, upvote_params, valid_session
            comment.reload
            expect(comment.votes).to eq(1)
            expect(comment.voters['up']).to eq([user.id])
            expect(comment.voters['down']).to eq([])

            put :update, downvote_params, valid_session
            comment.reload
            expect(comment.votes).to eq(0)
            expect(comment.voters['up']).to eq([])
            expect(comment.voters['down']).to eq([])
          end
        end

        context 'for an unenrolled course' do
          let(:course) { create :course }

          it 'does not allow user to vote' do
            put :update, upvote_params, valid_session
            expect(response.code).to eq("302")
          end
        end
      end
    end
  end

  context "for an admin" do
    before do
      topic
      sign_in admin
    end

    describe "#new" do
      before do
        topic
      end

      it "assigns a new topic" do
        get :new, { course_id: course.to_param }, valid_session
        expect(assigns(:comment)).to be_a_new(CourseComment)
      end

      it "sets the next available position" do
        get :new, { course_id: course.to_param }, valid_session
        expect(assigns(:comment).position).to eq(topic.position + 1)
      end
    end

    describe "#edit" do
      before do
        topic
      end

      it "assigns the requested comment as @comment" do
        get :edit, { course_id: course.to_param, id: topic.to_param }, valid_session
        expect(assigns(:comment)).to eq(topic)
      end
    end

    describe "#create" do
      context "a new topic" do
        let(:valid_params) do
          {
            course_id: course.to_param,
            course_comment: valid_admin_topic_attributes
          }
        end

        describe "with valid params" do
          it "creates a new comment" do
            expect {
              post :create, valid_params, valid_session
            }.to change(CourseComment, :count).by(1)
          end

          it "assigns a newly created comment as @comment" do
            post :create, valid_params, valid_session
            expect(assigns(:comment)).to be_a(CourseComment)
            expect(assigns(:comment)).to be_persisted
            expect(assigns(:comment).parent).to be_nil
            expect(assigns(:comment).position).to eq(1)
          end

          it "redirects to the course enrolled page" do
            post :create, valid_params, valid_session
            expect(response).to redirect_to(enrolled_course_path(course))
          end
        end

        describe "with invalid params" do
          it "returns an error response" do
            # Trigger the behavior that occurs when invalid params are submitted
            CourseComment.any_instance.stub(:save).and_return(false)
            post :create, valid_params, valid_session
            expect(response).to be_error
          end
        end
      end

      context "a new comment" do
        let(:valid_params) do
          {
            parent_id: topic.to_param,
            course_id: course.to_param,
            course_comment: valid_admin_topic_attributes
          }
        end

        it "creates a new comment" do
          expect {
            post :create, valid_params, valid_session
          }.to change(CourseComment, :count).by(1)
        end
      end
    end

    describe "#update" do
      context "when moderating a comment" do
        let(:valid_params) do
          {
            format: 'js',
            course_id: course.to_param,
            id: comment.to_param,
            course_comment: { visible: 'false' }
          }
        end

        it "updates a comment" do
          put :update, valid_params, valid_session
          comment.reload
          expect(comment.visible).to be_false
        end
      end

      context "when editing a topic" do
        let(:valid_params) do
          {
            course_id: course.to_param,
            id: comment.to_param,
            course_comment: { comment: 'foo', position: 9 }
          }
        end

        it "updates a comment" do
          put :update, valid_params, valid_session
          comment.reload
          expect(comment.comment).to eq('foo')
          expect(comment.position).to eq(9)
        end

      end
    end
  end


end
