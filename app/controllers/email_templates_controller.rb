class EmailTemplatesController < ApplicationController
  before_action :set_course
  before_action :set_admin
  before_action :set_email_template, except: [:new, :index, :create]
  after_filter :verify_authorized

  def index
    authorize(EmailTemplate)
    @email_templates = @course.email_templates.order(:kind)
  end

  def show
    authorize(@email_template)
  end

  def new
    @email_template = @course.email_templates.build
    authorize(@email_template)
  end

  def edit
    authorize(@email_template)
    @user = current_user.decorate
    begin
      @body_preview = ERB.new(@email_template.body).result(binding).html_safe
    rescue => e
      @body_preview = e.inspect
    end

    begin
      @subject_preview = ERB.new(@email_template.subject).result(binding).html_safe
    rescue => e
      @body_preview = e.inspect
    end
  end

  def create
    @email_template = @course.email_templates.build(email_template_params)
    authorize(@email_template)

    if @email_template.save
      redirect_to edit_course_email_template_path(@course, @email_template), notice: 'Email Template was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    authorize(@email_template)
    if @email_template.update(email_template_params)
      redirect_to edit_course_email_template_path(@course, @email_template), notice: 'Email Template was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize(@email_template)
    @email_template.destroy
    redirect_to course_email_templates_path(@course), notice: 'Email Template was successfully destroyed.'
  end


  private

  def set_email_template
    @email_template = EmailTemplate.find(params[:id])
  end

  def set_course
    @course = Course.friendly.find(params[:course_id]).decorate
  end

  # Only allow a trusted parameter "white list" through.
  def email_template_params
    params.require(:email_template).permit(:body, :subject, :from, :kind)
  end
end
