require 'spec_helper'

describe CouponsController do

  def valid_attributes
    attributes_for :coupon
  end

  def valid_session
    {}
  end

  before do
    sign_in build :admin
  end

  let(:course) { create :course }
  let(:coupon) { course.coupons.create! valid_attributes }

  describe "#index" do
    it "assigns all coupons as @coupons" do
      coupon
      get :index, { course_id: course.to_param }, valid_session
      expect(assigns(:coupons)).to eq([coupon])
    end
  end

  describe "#new" do
    it "assigns a new coupon as @coupon" do
      get :new, { course_id: course.to_param }, valid_session
      expect(assigns(:coupon)).to be_a_new(Coupon)
    end
  end

  describe "#edit" do
    it "assigns the requested coupon as @coupon" do
      coupon
      get :edit, { course_id: course.to_param, id: coupon.to_param }, valid_session
      expect(assigns(:coupon)).to eq(coupon)
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new Coupon" do
        expect {
          post :create, { course_id: course.to_param, coupon: valid_attributes }, valid_session
        }.to change(Coupon, :count).by(1)
      end

      it "assigns a newly created coupon as @coupon" do
        post :create, { course_id: course.to_param, coupon: valid_attributes }, valid_session
        expect(assigns(:coupon)).to be_a(Coupon)
        expect(assigns(:coupon)).to be_persisted
      end

      it "redirects to the coupons list" do
        post :create, { course_id: course.to_param, coupon: valid_attributes }, valid_session
        expect(response).to redirect_to(course_coupons_path(course))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved coupon as @coupon" do
        # Trigger the behavior that occurs when invalid params are submitted
        Coupon.any_instance.stub(:save).and_return(false)
        post :create, { course_id: course.to_param, coupon: valid_attributes }, valid_session
        expect(assigns(:coupon)).to be_a_new(Coupon)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Coupon.any_instance.stub(:save).and_return(false)
        post :create, { course_id: course.to_param, coupon: valid_attributes }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested coupon" do
        coupon
        # Assuming there are no other coupons in the database, this
        # specifies that the Coupon created on the previous line
        # receives the :update message with whatever params are submitted in
        # the request.
        Coupon.any_instance.should_receive(:update).with({ "code" => "MyString" })
        put :update, { :course_id => course.to_param, :id => coupon.to_param, :coupon => { "code" => "MyString" } }, valid_session
      end

      it "assigns the requested coupon as @coupon" do
        coupon
        put :update, { :course_id => course.to_param, :id => coupon.to_param, :coupon => valid_attributes }, valid_session
        expect(assigns(:coupon)).to eq(coupon)
      end

      it "redirects to the coupons list" do
        coupon
        put :update, { :course_id => course.to_param, :id => coupon.to_param, :coupon => valid_attributes }, valid_session
        expect(response).to redirect_to(course_coupons_path(course))
      end
    end

    describe "with invalid params" do
      it "assigns the coupon as @coupon" do
        coupon
        # Trigger the behavior that occurs when invalid params are submitted
        Coupon.any_instance.stub(:save).and_return(false)
        put :update, { :course_id => course.to_param, :id => coupon.to_param, :coupon => { "code" => "invalid value" } }, valid_session
        expect(assigns(:coupon)).to eq(coupon)
      end

      it "re-renders the 'edit' template" do
        coupon
        # Trigger the behavior that occurs when invalid params are submitted
        Coupon.any_instance.stub(:save).and_return(false)
        put :update, { :course_id => course.to_param, :id => coupon.to_param, :coupon => { "code" => "invalid value" } }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested coupon" do
      coupon
      expect {
        delete :destroy, { :course_id => course.to_param, :id => coupon.to_param }, valid_session
      }.to change(Coupon, :count).by(-1)
    end

    it "redirects to the coupons list" do
      coupon
      delete :destroy, { :course_id => course.to_param, :id => coupon.to_param }, valid_session
      expect(response).to redirect_to(course_coupons_path(course))
    end
  end

end
