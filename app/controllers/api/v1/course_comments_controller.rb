class Api::V1::CourseCommentsController < Api::V1::BaseController
  skip_after_filter :verify_authorized
  before_filter :set_user, only: [:index]

  def index
    if params[:result_only]
      if params[:user_id] && params[:course_id] && params[:offset]
        @results = CourseComment.where(
          user_id: params[:user_id],
          course_id: params[:course_id])
          .offset(params[:offset])
          .order('created_at DESC')

        @results = CourseCommentDecorator.decorate_collection(@results)

        render template: 'api/v1/course_comments/index_result_only.json.rabl'
        return
      end
    elsif params[:prev_id] || params[:last_id]
      set_search_result_vars(
        CourseComment.return_remaining_comments(params)
      )
      @results = CourseCommentDecorator.decorate_collection(@results)
    elsif params[:comment_id]
      @comment = CourseComment.find(params[:comment_id])

      @notification = Notification.where(notifiable_id: params[:comment_id]).first
      if @notification && @notification.viewed == false && current_user.id == CourseComment.find(@comment.parent_id).user_id
        @notification.viewed = true
        @notification.save!
      end

      depth = params[:depth] ? params[:depth] : @comment.depth
      set_search_result_vars(
        CourseComment.focused_search(
          comment_id: @comment.id,
          parent_id: @comment.parent_id,
          focus_id: params[:focus_id],
          focus_parent_id: params[:focus_parent_id],
          created_at: @comment.created_at,
          depth: depth,
          limit: 10,
          requester_id: params[:comment_id]
        )
      )
      @results = CourseCommentDecorator.decorate_collection(@results)
    else
      if params[:roots_only]
        set_search_result_vars(
          CourseComment.roots_only(params[:course_id], params[:chapter_id], 2).search(params))
      else
        set_search_result_vars(CourseComment.search(params))
      end
      @results = @results.decorate
    end
    @results
    render template: 'api/v1/course_comments/index.json.rabl'
  end

  def show

  end

  def create
    @ccg = CourseCommentGenerator.new(course_comment_params)
    if @ccg.save
      @course_comment = @ccg.course_comment.decorate
      render template: 'api/v1/course_comments/show.json.rabl'
    else
      @error = { message: 'awesome error' }.to_json
      render @error
    end
  end

  def update
    @comment = CourseComment.find(course_comment_params[:id])
    authorize(@comment)
    vote
    if @comment.save
      @course_comment = @comment.decorate
      render template: 'api/v1/course_comments/show.json.rabl'
    else
      @error = { message: 'awesome error'}.to_json
    end
  end

  private
    def set_user
      if params[:user_id] && current_user.nil?
        @current_user = User.find(params[:user_id]).decorate
      end
    end

    def course_comment_params
      params.require(:course_comment).permit!
    end

    def vote
      v = course_comment_params[:vote]
      @vote_type = v
      if v && policy(@comment).vote?
        voter = CommentVoter.new(current_user, @comment)
        voter.vote(v)
      end
    end
end
