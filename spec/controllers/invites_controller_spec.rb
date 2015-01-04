require 'spec_helper'

describe InvitesController do

  # This should return the minimal set of attributes required to create a valid
  # Message. As you add validations to Message, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { from: 'invite-me@example.com' }
  end

  def invalid_attributes
    { from: 'invite-me' }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MessagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before do
  end

  describe "#create" do
    describe "with valid params" do
      it "assigns a newly created message as @message" do
        post :create, { :message => valid_attributes }, valid_session
        expect(assigns(:message)).to be_a(Message)
      end

      it "redirects to the home page" do
        post :create, { :message => valid_attributes }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      it "redirects to the home page" do
        post :create, { :message => invalid_attributes }, valid_session
        expect(response).to redirect_to(root_path)
      end

      it "displays an error message" do
        post :create, { :message => invalid_attributes }, valid_session
        expect(flash[:alert]).to eq("Your email address doesn't seem to be valid.")
      end
    end

    describe "with an error" do
      before do
        AdminMailer.stub_chain(:invite_email, :deliver).and_raise(StandardError.new('Oops'))
      end

      it 'displays an error message' do
        post :create, { :message => valid_attributes }, valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("There was a problem: Oops")
      end
    end
  end

end
