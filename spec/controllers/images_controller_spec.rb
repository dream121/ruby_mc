require 'spec_helper'

describe ImagesController do

  # This should return the minimal set of attributes required to create a valid
  # Image. As you add validations to Image, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attrs = attributes_for(:image).tap do |a|
      a[:image] = fixture_file_upload('spec/factories/images/rails.png', 'image/png')
    end
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ImagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  let!(:course) { create :course }

  before do
    stub_request(:head, %r{test\.s3\.amazonaws\.com}).to_return status: 404, body: ''
    stub_request(:put, %r{test\.s3\.amazonaws\.com}).to_return status: 201, body: ''
    sign_in build :admin
  end

  describe "#new" do
    it "assigns a new image as @image" do
      get :new, { :course_id => course.to_param }, valid_session
      expect(assigns(:image)).to be_a_new(Image)
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new Image" do
        expect {
          post :create, { :course_id => course.to_param, :image => valid_attributes }, valid_session
        }.to change(Image, :count).by(1)
      end

      it "assigns a newly created image as @image" do
        post :create, { :course_id => course.to_param, :image => valid_attributes }, valid_session
        expect(assigns(:image)).to be_a(Image)
        expect(assigns(:image)).to be_persisted
      end

      it "redirects to the course" do
        post :create, { :course_id => course.to_param, :image => valid_attributes }, valid_session
        expect(response).to redirect_to(course_url(course.to_param))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved image as @image" do
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        post :create, { :course_id => course.to_param, :image => valid_attributes }, valid_session
        expect(assigns(:image)).to be_a_new(Image)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        post :create, { :course_id => course.to_param, :image => valid_attributes }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested image" do
      image = Image.create! valid_attributes
      expect {
        delete :destroy, { :course_id => course.to_param, :id => image.to_param }, valid_session
      }.to change(Image, :count).by(-1)
    end

    it "redirects to the course" do
      image = Image.create! valid_attributes
      delete :destroy, { :course_id => course.to_param, :id => image.to_param }, valid_session
      expect(response).to redirect_to(course_url(course.to_param))
    end
  end

end
