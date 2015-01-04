class CourseCommentsController < ApplicationController
  before_action :set_admin, only: [:edit]
  before_action :set_course
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  after_filter :verify_authorized, except: [:index]

  # new topic
  def index

  end

  def new
    last = CourseComment.for_course(@course).order(:position).last
    position = last ? last.position.to_i + 1 : 1
    @comment = @course.comments.build(user: current_user, position: position)
    authorize(@comment)
  end

  # show topic
  def show
    authorize(@comment)
  end

  # edit topic
  def edit
    authorize(@comment)
  end

  # create comment or topic
  def create 
    @comment = @course.comments.build(comment_params)
    if parent_id_param.present?
      @comment.parent = @course.comments.find(parent_id_param)
    end

    # strip default text

    authorize(@comment)

    @comment.user = current_user
    @comment.visible = true
    if @comment.save
      if params[:course_comment][:image].present?
        image = Image.create(image: params[:course_comment][:image])
        puts "image detected"
        @comment.image = image
        redirect_to watch_course_chapter_path(@course, params[:chapter]) 
      else 
        if @comment.parent #removing AJAX
          @chapterid = params[:chapter]

          render partial: 'comment', layout: false, locals: { comment: @comment, chapter: @chapterid}
        #if @comment.parent
        #  redirect_to course_topic_path(@course, @comment.ancestors.first) 
        else
          flash[:notice] = "Created new topic"
          redirect_to enrolled_course_path(@course)
        end
      end
    else
      head :error
    end
  end

  def update
    authorize(@comment)

    respond_to do |format|
      format.js do
        vote
        moderate
        @comment.save!
      end

      format.html do
        update_topic
      end
    end
  end

  private

  def moderate
    if policy(@comment).moderate?
      if visible = params[:course_comment][:visible]
        @comment.visible = visible == 'true' ? true : false
      end
    end
  end

  def vote
    v = params[:course_comment][:vote]
    if v && policy(@comment).vote?
      voter = CommentVoter.new(current_user, @comment)
      voter.vote(v)
    end
  end

  def update_topic
    if policy(@comment).moderate?
      @comment.update_attributes(comment_params)
      flash[:notice] = 'Topic updated'
      redirect_to enrolled_course_path(@course)
    else
      head :error
    end
  end

  def set_course
    @course = Course.friendly.find(params[:course_id]).decorate
  end

  def set_comment
    @comment = CourseComment.find(params[:id])
  end

  def comment_params
    if current_user.admin?
      params.require(:course_comment).permit(:comment, :position, :chapter_id)
    else
      params.require(:course_comment).permit!(:comment, :chapter_id)
    end
  end

  def parent_id_param
    if current_user.admin?
      params.permit(:parent_id)[:parent_id]
    else
      params.require(:parent_id)
    end
  end
end
