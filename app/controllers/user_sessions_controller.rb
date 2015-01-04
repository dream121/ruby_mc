class UserSessionsController < ApplicationController

  skip_before_filter :require_login, except: [:destroy]

  # CSRF only applies to the developer sign in form, which fails when this is enabled.
  skip_before_filter :verify_authenticity_token

  skip_after_filter :verify_authorized, :verify_policy_scoped

  attr_writer :authenticator

  def authenticator
    @authenticator ||= UserAuthenticator.new
  end

  def new
    track_event 'accounts.sign-in-form'
    render_with_layout
  end

  def sign_up
    track_event 'accounts.sign-up-form'
    @identity = env['omniauth.identity']
    # render_with_layout
    render json: {status: "email exists"}.to_json, status: 200 and return
  end

  def create
    begin
      if current_user
        user = authenticator.connect_user_with_auth(env['omniauth.auth'], current_user)
      else
        user = authenticator.user_from_auth(env['omniauth.auth'])
      end

      if user
        session[:user_id] = user.id
        track_event 'accounts.sign-in'
        if request.xhr? # ajax request
          flash[:notice] = "Signed in!"
          render json: {status: "success", redirect_to: redirect_path_for(user)}.to_json, status: 200 and return
        else
          redirect_to redirect_path_for(user), notice: "Signed in!"
        end
      else
        message = "No user exists for that authorization."
        track_event 'accounts.sign-in.error', message: message
        redirect_to sign_in_path, alert: message
      end
    rescue UserAuthenticator::UserAuthenticatorError => e
      # user tried to create an email login
      # when an existing Facebook login exists.
      track_event 'accounts.sign-up.error', message: e.message
      redirect_to sign_in_path, alert: e.message
    rescue UserAuthenticator::FacebookAuthError => e
      redirect_to edit_account_path, alert: e.message
    end
  end

  def failure
    message = case params['strategy']
    when 'identity'
      # TODO: if user tried to login with an email
      # that is associated with a Facebook user, give
      # them a more helpful error message.
      "Email or password incorrect."
    else
      "Authentication failed."
    end
    track_event 'accounts.sign-in.error', message: message
    render json: {status: "failed"}.to_json, status: 200 and return
    # redirect_to sign_in_path, alert: message
  end

  def destroy
    track_event 'accounts.sign-out'
    session[:user_id] = nil
    redirect_to root_path, notice: "Signed out!"
  end

  private

  def render_with_layout
    if session[:requested_path]
      referrer = session[:requested_path]
    elsif request.referer
      referrer = URI(request.referer).path
    end

    unless referrer && referrer.match(/^\/courses/)
      render layout: 'root'
    end
  end

  def identity_params
    params.permit(:email, :name, :password, :password_confirmation)
  end

  # if user has courses and logged in via root, send to courses listing
  def redirect_path_for(user)
    requested_path = session.delete(:requested_path)
    requested_path_from_cookie = cookies.delete(:requested_path)
    if requested_path_from_cookie
      requested_path_from_cookie
    elsif requested_path
      requested_path
    elsif user.courses.any?
      root_path
    else
      root_path
    end
  end

end
