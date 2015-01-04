class UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_admin, only: [:index, :edit, :show]
  after_filter :verify_authorized

  def index
    authorize(User.new)
    @users = policy_scope(User).all.order('created_at DESC')
  end

  def show
  end

  def edit
    @instructors = Instructor.all
  end

  def update
    if params[:user][:permissions]
      @user.update_permissions(params[:user][:permissions])
    end

    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
