class Api::V1::UserCoursesController < Api::V1::BaseController
  respond_to :json
  before_action :set_user_course

  def update
    if @user_course.update_progress user_course_params[:progress]
      head :ok
    else
      # TODO: report error?
      head :bad_request
    end
  end

  private

  def set_user_course
    @user_course = UserCourse.find(params[:id])
    authorize(@user_course, :api_update?)
  end

  def user_course_params
    params.require(:user_course).permit(progress: [ :chapter_id, :position, :duration ])
  end
end
