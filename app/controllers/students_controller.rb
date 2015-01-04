class StudentsController < ApplicationController
  before_action :require_login
  before_action :set_user, except: [:show]
  before_action :set_profile
  before_action :get_courses, only: [:show, :edit]
  after_filter :verify_authorized, except: [:show]

  rescue_from Pundit::NotAuthorizedError, :with => :redirect_to_show

  decorates_assigned :profile, :user

  def show
    @user = @profile.user

    redirect_to edit_student_path if @user == current_user
  end

  def edit
    authorize @profile
  end

  def update
    authorize @profile, :update?

    respond_to do |format|
      if @profile.update_attributes(profile_params)
        format.json { render json: @profile, status: 200 }
      else
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def profile_params
      params.require(:profile).permit(:display_name, :tagline, :city, :country)
    end

    def set_user
      @user = current_user
    end

    def set_profile
      @profile = Profile.find(params[:id])
    end

    def get_courses
      @in_progress_courses = @profile.user.user_courses.decorate.reject(&:completed?)
      @completed_courses   = @profile.user.user_courses.decorate.select(&:completed?)
    end

    def redirect_to_show
      redirect_to student_path
    end
end
