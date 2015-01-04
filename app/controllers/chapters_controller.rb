class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :watch, :edit, :update, :destroy, :move, :lock]
  before_action :set_course
  before_action :set_admin, only: [:new, :edit, :update, :destroy]
  after_filter :verify_authorized

  include SlugsHelper

  def show
    authorize(@chapter)
    track_event 'chapters.show', course: @course.title, chapter: @chapter.title
  end

  # watch_course_chapter_path
  def watch
    authorize(@chapter)
    current_user_course(@course)
    if @user_course
      track_event 'chapters.enrolled.watch', course: @course.title, chapter: @chapter.title
      progress = @user_course.progress_for_chapter(@chapter.id)
      @chapter_position = progress.position
    else
      @chapter_position = 0
    end

    # previous and next links
    next_lesson             = @chapter.next_for_course
    prv_lesson              = @chapter.previous_for_course
    if next_lesson.present?
      @next_path            = watch_course_chapter_path(@course, next_lesson)
    else
      @next_path            = "#"
    end
    if prv_lesson.present?
      @prv_path             = watch_course_chapter_path(@course, prv_lesson)
      @prv_label            = "previous lesson"
    else
      @prv_path             = enrolled_course_path(@course)
      @prv_label            = "lesson plan"
    end

    @base_comment      = CourseComment.roots.where(chapter_id: @chapter.id).first
    @discussions_count = CourseComment.where(parent_id: @base_comment.id).count if @base_comment
    @user              = @current_user.decorate
    render :layout => "layouts/watch"
  end

  def new
    @chapter = @course.chapters.build
    authorize(@chapter)
  end

  def edit
    authorize(@chapter)
  end

  def create
    @chapter = @course.chapters.build(chapter_params)
    authorize(@chapter)

    if @chapter.save
      update_slug(@chapter, chapter_params[:slug])
      redirect_to edit_course_path(@course), notice: 'Chapter was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    authorize(@chapter)
    if @chapter.update(chapter_params)
      update_slug(@chapter, chapter_params[:slug])
      redirect_to edit_course_path(@course), notice: 'Chapter was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize(@chapter)
    @chapter.destroy
    redirect_to @course, notice: 'Chapter was successfully destroyed.'
  end

  def move
    authorize(@chapter)
    params[:direction] == 'up' ? @chapter.move_higher : @chapter.move_lower

    redirect_to edit_course_path(@course), notice: 'Chapter was successfully updated.'
  end

  private

  def set_chapter
    @chapter = Chapter.friendly.find(params[:id])
  end

  def set_course
    @course = Course.friendly.find(params[:course_id]).decorate
  end

  # Only allow a trusted parameter "white list" through.
  def chapter_params
    params.require(
      :chapter
    ).permit(
      :number,
      :duration,
      :abstract,
      :title,
      :slug,
      :brightcove_id,
      :video_description,
      :is_bonus,
      :unlock_qty
    )
  end
  # Overridden from the application controller 
  # so that redirection to the course marketing page 
  # is possible.
  def user_not_authorized(e)
    flash[:error] = "Please enroll in the class to see this content."
    redirect_to @course
  end
end
