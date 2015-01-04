require 'spec_helper'

describe EmailTemplatesController do

  def valid_attributes
    attributes_for :email_template
  end

  def valid_session
    {}
  end

  before do
    sign_in build :admin
  end

  let(:course) { create :course }
  let(:email_template) { course.email_templates.create! valid_attributes }

  describe "#index" do
    it "assigns all email_templates as @email_templates" do
      email_template
      get :index, { course_id: course.to_param }, valid_session
      expect(assigns(:email_templates)).to eq([email_template])
    end
  end

  describe "#new" do
    it "assigns a new email_template as @email_template" do
      get :new, { course_id: course.to_param }, valid_session
      expect(assigns(:email_template)).to be_a_new(EmailTemplate)
    end
  end

  describe "#edit" do
    it "assigns the requested email_template as @email_template" do
      email_template
      get :edit, { course_id: course.to_param, id: email_template.to_param }, valid_session
      expect(assigns(:email_template)).to eq(email_template)
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new EmailTemplate" do
        expect {
          post :create, { course_id: course.to_param, email_template: valid_attributes }, valid_session
        }.to change(EmailTemplate, :count).by(1)
      end

      it "assigns a newly created email_template as @email_template" do
        post :create, { course_id: course.to_param, email_template: valid_attributes }, valid_session
        expect(assigns(:email_template)).to be_a(EmailTemplate)
        expect(assigns(:email_template)).to be_persisted
      end

      it "redirects to the created email_template" do
        post :create, { course_id: course.to_param, email_template: valid_attributes }, valid_session
        expect(response).to redirect_to(edit_course_email_template_path(course, EmailTemplate.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved email_template as @email_template" do
        # Trigger the behavior that occurs when invalid params are submitted
        EmailTemplate.any_instance.stub(:save).and_return(false)
        post :create, { course_id: course.to_param, email_template: valid_attributes }, valid_session
        expect(assigns(:email_template)).to be_a_new(EmailTemplate)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        EmailTemplate.any_instance.stub(:save).and_return(false)
        post :create, { course_id: course.to_param, email_template: valid_attributes }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested email_template" do
        EmailTemplate.any_instance.should_receive(:update).with({ "from" => "MyString" })
        put :update, { :course_id => course.to_param, :id => email_template.to_param, :email_template => { "from" => "MyString" } }, valid_session
      end

      it "assigns the requested email_template as @email_template" do
        put :update, { :course_id => course.to_param, :id => email_template.to_param, :email_template => valid_attributes }, valid_session
        expect(assigns(:email_template)).to eq(email_template)
      end

      it "redirects to the email_template" do
        put :update, { :course_id => course.to_param, :id => email_template.to_param, :email_template => valid_attributes }, valid_session
        expect(response).to redirect_to(edit_course_email_template_path(course, email_template))
      end
    end

    describe "with invalid params" do
      it "assigns the email_template as @email_template" do
        EmailTemplate.any_instance.stub(:save).and_return(false)
        put :update, { :course_id => course.to_param, :id => email_template.to_param, :email_template => { "from" => "invalid value" } }, valid_session
        expect(assigns(:email_template)).to eq(email_template)
      end

      it "re-renders the 'edit' template" do
        EmailTemplate.any_instance.stub(:save).and_return(false)
        put :update, { :course_id => course.to_param, :id => email_template.to_param, :email_template => { "from" => "invalid value" } }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested email_template" do
      email_template
      expect {
        delete :destroy, { :course_id => course.to_param, :id => email_template.to_param }, valid_session
      }.to change(EmailTemplate, :count).by(-1)
    end

    it "redirects to the email_templates list" do
      delete :destroy, { :course_id => course.to_param, :id => email_template.to_param }, valid_session
      expect(response).to redirect_to(course_email_templates_path(course))
    end
  end

end
