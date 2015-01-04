require 'spec_helper'

describe DocumentsController do

  # This should return the minimal set of attributes required to create a valid
  # Document. As you add validations to Document, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attrs = attributes_for(:document).tap do |a|
      a[:document] = fixture_file_upload('spec/factories/images/rails.png', 'image/png')
    end
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DocumentsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  let(:course) { create :course }

  before do
    stub_request(:head, %r{test\.s3\.amazonaws\.com}).to_return status: 404, body: ''
    stub_request(:put, %r{test\.s3\.amazonaws\.com}).to_return status: 201, body: ''
    sign_in build :admin
  end

  describe "#new" do
    it "assigns a new document as @document" do
      get :new, { :course_id => course.to_param }, valid_session
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe "#edit" do
    it "assigns the requested document as @document" do
      document = Document.create! valid_attributes
      get :edit, { :course_id => course.to_param, :id => document.to_param }, valid_session
      expect(assigns(:document)).to eq(document)
    end
  end

  describe "#download" do
    it "redirects to the S3 file URL" do
      document = Document.create! valid_attributes
      get :download, { :course_id => course.to_param, :id => document.to_param }, valid_session
      expect(response).to redirect_to( %r(\Ahttps://test.s3.amazonaws.com))
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new Document" do
        expect {
          post :create, { :course_id => course.to_param, :document => valid_attributes }, valid_session
        }.to change(Document, :count).by(1)
      end

      it "assigns a newly created document as @document" do
        post :create, { :course_id => course.to_param, :document => valid_attributes }, valid_session
        expect(assigns(:document)).to be_a(Document)
        expect(assigns(:document)).to be_persisted
      end

      it "redirects to the course" do
        post :create, { :course_id => course.to_param, :document => valid_attributes }, valid_session
        expect(response).to redirect_to(course)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document as @document" do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, { :course_id => course.to_param, :document => { "kind" => "invalid value" } }, valid_session
        expect(assigns(:document)).to be_a_new(Document)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, { :course_id => course.to_param, :document => { "kind" => "invalid value" } }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested document" do
        document = Document.create! valid_attributes
        # Assuming there are no other documents in the database, this
        # specifies that the Document created on the previous line
        # receives the :update message with whatever params are submitted in
        # the request.
        Document.any_instance.should_receive(:update).with({ "kind" => "MyString" })
        put :update, { :course_id => course.to_param, :id => document.to_param, :document => { "kind" => "MyString" } }, valid_session
      end

      it "assigns the requested document as @document" do
        document = Document.create! valid_attributes
        put :update, { :course_id => course.to_param, :id => document.to_param, :document => valid_attributes }, valid_session
        expect(assigns(:document)).to eq(document)
      end

      it "redirects to the course" do
        document = Document.create! valid_attributes
        put :update, { :course_id => course.to_param, :id => document.to_param, :document => valid_attributes }, valid_session
        expect(response).to redirect_to(course)
      end
    end

    describe "with invalid params" do
      it "assigns the document as @document" do
        document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, { :course_id => course.to_param, :id => document.to_param, :document => { "kind" => "invalid value" } }, valid_session
        expect(assigns(:document)).to eq(document)
      end

      it "re-renders the 'edit' template" do
        document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, { :course_id => course.to_param, :id => document.to_param, :document => { "kind" => "invalid value" } }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested document" do
      document = Document.create! valid_attributes
      expect {
        delete :destroy, { :course_id => course.to_param, :id => document.to_param }, valid_session
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the course" do
      document = Document.create! valid_attributes
      delete :destroy, { :course_id => course.to_param, :id => document.to_param }, valid_session
      expect(response).to redirect_to(course)
    end
  end

end
