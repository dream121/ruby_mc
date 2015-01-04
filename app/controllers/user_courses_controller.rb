class UserCoursesController < ApplicationController
  before_action :set_course, only: [:index, :prospects]
  before_action :set_user_course, except: [:index, :prospects]
  before_action :set_admin, only: [:index, :edit, :prospects]
  after_filter :verify_authorized

  def edit
  end

  def update
    if @user_course.update(user_course_params)
      redirect_to @user_course.user, notice: 'User course was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def index
    authorize(UserCourse)
    @user_courses = @course.user_courses.order('created_at DESC')
  end

  def prospects
    authorize(UserCourse)
    @users = UsersWithoutCourseQuery.new.find(@course)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_course
      @user_course = UserCourse.find(params[:id])
      authorize(@user_course)
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_course_params
      params.require(:user_course).permit(:access)
    end
end
