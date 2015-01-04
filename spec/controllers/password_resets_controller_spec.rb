require 'spec_helper'

describe PasswordResetsController do

  let(:identity) { create :identity }

  def valid_attributes
    {'password' => 'newpass', 'password_confirmation' => 'newpass' }
  end

  def invalid_attributes
    {'password' => 'newpass', 'password_confirmation' => 'mismatch' }
  end

  def valid_session
    {}
  end

  def set_token
    identity.update_attribute(:password_reset_token, 'TOKEN')
    identity.update_attribute(:password_reset_sent_at, Time.now)
  end

  describe "#new" do
    it "renders the new template" do
      get :new, {}, valid_session
      expect(response).to render_template('new')
    end
  end

  describe "#edit" do
    context "with a valid token" do
      before do
        set_token
      end

      it "assigns the requested identity as @identity" do
        get :edit, { :id => identity.password_reset_token }, valid_session
        expect(assigns(:identity)).to eq(identity)
      end
    end

    context "with an expired token" do
      before do
        Timecop.freeze(1.day.ago) do
          set_token
        end
      end

      it "redirects to the root" do
        get :edit, { :id => identity.password_reset_token }, valid_session
        expect(response).to redirect_to(new_password_reset_path)
      end
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "sends an email" do
        expect {
          post :create, { email: identity.email }, valid_session
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it "redirects to the root url" do
        post :create, { email: identity.email }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      it "sends no email" do
        expect {
          post :create, { email: 'nobody@example.com' }, valid_session
        }.to_not change(ActionMailer::Base.deliveries, :count)
      end

      it "redirects to the root url" do
        post :create, { email: 'nobody@example.com' }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      before do
        set_token
      end

      it "updates the requested password_reset" do
        Identity.any_instance.should_receive(:update).with(valid_attributes)
        put :update, { :id => 'TOKEN', :identity => valid_attributes }, valid_session
      end

      it "redirects to the root url" do
        put :update, { :id => 'TOKEN', :identity => valid_attributes }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "with an expired token" do
      before do
        Timecop.freeze(1.day.ago) do
          set_token
        end
        put :update, { :id => 'TOKEN', :identity => valid_attributes }, valid_session
      end

      it "redirects to the new password path" do
        expect(response).to redirect_to(new_password_reset_path)
      end
    end

    describe "with a mismatched password and confirmation" do
      before do
        set_token
      end

      it "renders the edit template" do
        put :update, { :id => 'TOKEN', :identity => invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end

  end
end
