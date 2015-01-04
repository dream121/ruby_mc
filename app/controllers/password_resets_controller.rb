class PasswordResetsController < ApplicationController
  def new
  end

  def edit
    @identity = Identity.find_by!(password_reset_token: params[:id])
    
    if @identity
      track_event 'password-resets.edit', email: @identity.email
      redirect_to root_path(reset_password_token: params[:id])  
    end
    
    
    # if @identity.password_reset_expired?
      # redirect_to new_password_reset_path, alert: 'Password reset has expired'
    # end
  end

  def create
    result = UserAuthenticator.new.send_password_reset(params[:email])
    
    track_event 'password-resets.create', email: params[:email]
    
    if result
      render json: {status: "success"}.to_json, status: 200 and return
    else
      render json: {status: "failed"}.to_json, status: 200 and return
    end
    
    # redirect_to root_path, notice: 'Email sent with password reset instructions.'
  end

  def update
    @identity = Identity.find_by!(password_reset_token: params[:id])
    track_event 'password-resets.update', email: @identity.email
    
    if @identity.password_reset_expired?
    
      flash[:alert] = 'Password reset has expired'      
      # redirect_to new_password_reset_path, alert: 'Password reset has expired'
      render json: {status: "expired"}.to_json, status: 200 and return
    else
      if reset_password(@identity)
        track_event 'password-resets.update.success', email: @identity.email
        flash[:notice] = 'Password has been reset! Please log in again.'
        # redirect_to root_path, notice: 'Password has been reset! Please log in again.'
        render json: {status: "success"}.to_json, status: 200 and return
      else
        # render 'edit'
        render json: {status: "failed"}.to_json, status: 200 and return
      end
    end
  end

  private

  def reset_password(identity)
    UserAuthenticator.new.reset_password(identity, password_reset_params)
  end

  def password_reset_params
    params.require(:identity).permit(:password, :password_confirmation)
  end
end
