class MessagesController < ApplicationController
  before_action :set_course
  after_filter :verify_authorized

  def new
    authorize(@course, :new_message?)
    track_event 'messages.new', course: @course.title
    @message = Message.new
  end

  def create
    authorize(@course, :create_message?)
    @message = Message.new(message_params)
    @message.from = current_user.email
    @message.to = @course.decorate.instructor_email

    if @message.valid?
      InstructorMailer.instructor_email(current_user, @course, @message).deliver
      track_event 'messages.create', course: @course.title
      redirect_to enrolled_course_path(@course), notice: 'Message sent.'
    else
      render action: 'new'
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  # Only allow a trusted parameter "white list" through.
  def message_params
    params.require(:message).permit(:subject, :body)
  end
end
