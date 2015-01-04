require 'spec_helper'

describe AccountsController do

  def valid_user_attributes
    { "name" => "New Name", "email" => "new@example.com" }
  end

  def valid_password_attributes
    { "password" => "newpass", "password_confirmation" => "newpass"}
  end

  def valid_session
    {}
  end

  let(:user) { create :user }

  before do
    sign_in user
  end

  describe "#show" do
    it "assigns the current user as @user" do
      get :show, {}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#edit" do
    it "assigns the requested user as @user" do
      get :show, {}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#update" do
    describe "with password params" do
      context "when valid" do
        before do
          UserAuthenticator.any_instance.stub(:update_password).and_return(true)
        end

        it "redirects to the accounts path" do
          put :update, { :user => valid_user_attributes, :old_password => 'old' }, valid_session
          expect(response).to redirect_to(account_path)
        end
      end

      context "when invalid" do
        before do
          UserAuthenticator.any_instance.stub(:update_password).and_return(false)
        end

        it "renders edit" do
          put :update, { :user => valid_user_attributes, :old_password => 'old' }, valid_session
          expect(response).to render_template('edit')
        end
      end
    end

    describe "with user params" do
      context "when valid" do
        it "updates the requested user" do
          put :update, { :user => valid_user_attributes }, valid_session
          user.reload
          expect(user.name).to eq 'New Name'
          expect(user.email).to eq 'new@example.com'
        end

        it "assigns the requested user as @user" do
          put :update, { :user => valid_user_attributes }, valid_session
          expect(assigns(:user)).to eq(user)
        end

        it "redirects to the account path" do
          put :update, { :user => valid_user_attributes }, valid_session
          expect(response).to redirect_to(account_path)
        end
      end
    end

    describe "when invalid" do
      it "assigns the user as @user" do
        User.any_instance.stub(:save).and_return(false)
        put :update, { :user => valid_user_attributes }, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        User.any_instance.stub(:save).and_return(false)
        put :update, { :user => valid_user_attributes }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

end
