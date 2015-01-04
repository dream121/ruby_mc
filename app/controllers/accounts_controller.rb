class AccountsController < ApplicationController
  before_filter :require_login
  before_action :set_user
  # before_filter :set_account, only: [:edit]
  after_filter :verify_authorized

  def add_image
    authorize @user, :edit_account?
    @user.decorate
    @user.profile_photo_url = params[:url]

    if @user.save
      if params[:context] == 'profile'
        render json: { html: @user.profile_pic }
      else
        render json: { html: @user.account_pic }
      end
    else
      render json: { error: 'image could not be saved'}
    end
  end

  def add_profile_image
    render json: params
  end

  def remove_image
    authorize @user, :edit_account?
    @user.profile_photo_url = nil

    if @user.save
      render json: { html: @user.account_pic }
    else
      render json: @user.errors
    end
  end

  def show
      # render template: 'accounts/show.json.rabl'
    authorize @user, :show_account?
  end

  def edit
    authorize @user, :edit_account?
    track_event 'accounts.edit'
    render :edit, layout: 'accounts'
  end

  def update
    authorize @user, :update_account?
    track_event 'accounts.update'
    if @user.update(account_params)
      if params[:old_password].present?
        if update_password
          track_event 'accounts.update-password'
        else
          render action: 'edit', layout: 'accounts'
          return
        end
      end
      redirect_to edit_account_path, notice: 'Account was successfully updated.'
    else
      render action: 'edit', layout: 'accounts'
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to root_path
  end

  private

  def update_password
    authenticator = UserAuthenticator.new
    authenticator.update_password(@user, params[:old_password], password_params)
  end

  def set_user
    @user = current_user.decorate
  end

  def account_params
    address           = [:line_one, :line_two, :city, :state_id, :country_id, :zip_code]
    enrolled_classes  = [:answered_question, :reply_at_me]
    general_info      = [:new_class_available, :monthly_newsletter]
    privacy_settings  = [:visibility]
    params.require(:user).permit(
      :first_name, :last_name,
      address: address,
      email_settings: [:email, enrolled_classes: enrolled_classes, general_info: general_info],
      privacy_settings: privacy_settings
    )
  end


  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
