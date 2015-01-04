class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  before_action :set_parent, only: [:edit, :new, :create, :update, :destroy]
  before_action :set_admin
  after_filter :verify_authorized

  include DocumentsHelper

  def new
    @image = build_image(nil)
    set_image_form_resource
    authorize(@image)
  end

  def create
    @image = build_image(image_params)
    authorize(@image)
    if @course
      redirect_path = edit_course_path(@course)
    elsif home_page?
      redirect_path = home_page_edit_path
    else
      redirect_path = @parent
    end

    if @image.save
      if comment?
        redirect_to course_topic_path(@course, @parent.parent)
      else
        redirect_to redirect_path, notice: 'Image was successfully created.'
      end
    else
      render action: 'new'
    end
  end

  def destroy
    @image.destroy
    if comment?
      redirect_to course_topic_path(@course, @parent.parent)
    elsif home_page?
      redirect_to home_page_edit_path, notice: 'Image was successfully destroyed.'
    else
      redirect_to @parent, notice: 'Image was successfully destroyed.'
    end
  end


  private

  def set_parent
    if fact?
      @parent = CourseFact.find(params[:fact_id]).decorate
      @course = Course.friendly.find(params[:course_id])
    elsif comment?
      @parent = CourseComment.find(params[:comment_id]).decorate
      @course = Course.friendly.find(params[:course_id])
    elsif home_page?
      @parent = HomePage.find(params[:home_page_id]).decorate 
    else
      super
    end
  end

  def fact?
    'fact' == params[:parent]
  end

  def comment?
    'comment' == params[:parent]
  end

  def home_page?
    params[:home_page_id].present?
  end

  def set_image_form_resource
    if fact?
      @image_resource = [@course, @parent, @image]
      @form_path = course_fact_image_path(@course, @parent, @image)
    elsif comment?
      @parent = CourseComment.find(params[:comment_id]).decorate 
      @image_resource = [@course, @parent, @image]
      @form_path = course_comment_image_path(@course, @parent, @image)
    elsif home_page?
      @image_resource = [@parent, @image]
      @form_path = nil
    else
      @image_resource = [@parent, @image]
      @form_path = nil
    end
  end

  def build_image(image_params)
    if @parent.respond_to?(:image)
      @parent.build_image(image_params)
    elsif @parent.respond_to?(:images)
      @parent.images.build(image_params)
    end
  end

  def set_image
    @image = Image.find(params[:id])
    authorize(@image)
  end

  def image_params
    params.require(:image).permit(:kind, :image)
  end
end
