class Api::V1::UploadsController < Api::V1::BaseController
  respond_to :json
  before_action :set_course

  def create
    @upload = @course.uploads.build(upload_params)
    authorize @upload

    if @upload.save
      render template: 'api/v1/courses/upload.json.rabl'
    else
      head :error
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    authorize @upload

    if @upload.destroy
      render json: @upload
    else
      head :error
    end
  end

  def update
    @upload = Upload.find(params[:id])
    authorize @upload

    if @upload.update(upload_params)
      head :ok
    else
      head :error
    end
  end

  private

    def upload_params
      params.require(:upload).permit!
    end

    def set_course
      @course = Course.find(params[:course_id])
    end
end
