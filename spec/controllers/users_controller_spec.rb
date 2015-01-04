require 'spec_helper'

describe UsersController do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :user
  end

  # This returns the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before do
    sign_in build :admin
  end

  describe "#index" do
    it "assigns all users as @users" do
      user = create :user
      get :index, {}, valid_session
      expect(assigns(:users)).to eq([user])
    end
  end

  describe "#show" do
    it "assigns the requested user as @user" do
      user = create :user
      get :show, { id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#edit" do
    it "assigns the requested user as @user" do
      user = create :user
      get :edit, { id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested user" do
        user = create :user
        # Assuming there are no other users in the database, this
        # specifies that the User created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update_attributes).with({ "email" => "test@example.com" })
        put :update, { id: user.to_param, user: { "email" => "test@example.com" } }, valid_session
      end

      it "assigns the requested user as @user" do
        user = create :user
        put :update, { id: user.to_param, user: valid_attributes }, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "updates permissions" do
        user = create :user, permissions: { "admin" => true, "comments" => true }
        expect(user.admin?).to be_true
        put :update, { id: user.to_param, user: valid_attributes }, valid_session
        expect(assigns(:user)).to eq(user)
        expect(assigns(:user).admin?).to be_false
      end

      it "redirects to the user" do
        user = create :user
        put :update, { id: user.to_param, user: valid_attributes }, valid_session
        expect(response).to redirect_to(user)
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = create :user
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, { id: user.to_param, user: { "email" => "invalid value" } }, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = create :user
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, { id: user.to_param, user: { "email" => "invalid value" } }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested user" do
      user = create :user
      expect {
        delete :destroy, { id: user.to_param }, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = create :user
      delete :destroy, { id: user.to_param }, valid_session
      expect(response).to redirect_to(users_url)
    end
  end

end
