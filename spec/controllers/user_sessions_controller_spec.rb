require 'spec_helper'

describe UserSessionsController do
  describe "#create" do
    context "given valid auth data" do
      let(:user) { build(:user, id: 1234) }

      before do
        stub = double()
        stub.stub(:user_from_auth).and_return user
        controller.authenticator = stub
        allow_event_tracker 'accounts.sign-in', {}
      end

      it "should set the user_id in the session" do
        get :create, provider: 'developer'
        expect(request.session[:user_id]).to eq 1234
      end

      it "should redirect to the requested url when it's set" do
        request.session[:requested_path] = '/users/1'
        get :create, provider: 'developer'
        expect(response).to redirect_to '/users/1'
      end

      it "should redirect to the root_path when it isn't set" do
        get :create, provider: 'developer'
        expect(response).to redirect_to courses_path
      end

      context "given a user with purchased courses" do
        before do
          User.any_instance.stub(:courses).and_return ['course']
        end

        it "should redirect to the user's courses list" do
          get :create, provider: 'developer'
          expect(response).to redirect_to(enrolled_courses_path)
        end
      end
    end

    context "given invalid auth data" do
      before do
        stub = double()
        stub.stub(:user_from_auth).and_return nil
        controller.authenticator = stub
        allow_event_tracker 'accounts.sign-in.error', { message: "No user exists for that authorization." }
      end

      it "should redirect to sign_in and report a failure" do
        get :create, provider: 'developer'
        expect(response).to redirect_to sign_in_path
        expect(flash[:alert]).to have_content('No user exists for that authorization.')
      end
    end
  end

  describe "#destroy" do
    it "should clear the user_id from the session" do
      controller.stub(:current_user).and_return build(:user, id: 1234)
      request.session[:user_id] = 1234
      allow_event_tracker 'accounts.sign-out', {}

      post :destroy
      expect(request.session[:user_id]).to be_nil
    end
  end

  describe "#new" do

    before do
      allow_event_tracker 'accounts.sign-in-form', {}
    end

    context "when signing in via the course marketing page" do
      before do
        request.stub(:referer).and_return "http://example.com/courses/foo"
      end

      it "should render sign-in using the application layout" do
        get :new
        expect(response).to render_template(layout: 'application')
      end
    end

    context "when being redirected to signin from the course enrolled page" do
      before do
        request.session[:requested_path] = "/courses/foo"
      end

      it "should render sign-in using the application layout" do
        get :new
        expect(response).to render_template(layout: 'application')
      end
    end

    context "when visiting sign-in directly" do
      it "should render sign-in using the root layout" do
        get :new
        expect(response).to render_template(layout: 'root')
      end
    end

    context "when visiting sign-in via any other path" do
      before do
        request.session[:requested_path] = "/foo/bar/baz"
      end

      it "should render sign-in using the root layout" do
        get :new
        expect(response).to render_template(layout: 'root')
      end
    end
  end
end
