class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  before_filter :fix_format
  before_filter :kiss_metrics_init
  before_filter :fetch_notifications
  before_filter :fetch_courses
  before_filter :set_facebook_key

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  helper_method :current_user, :logged_in?

  # apparently some mobile browsers set the Accept header incorrectly
  def fix_format
    request.format = :html if request.format == 'application/text'
  end

  def current_user
    @current_user ||= begin
      User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def current_user_course(course)
    @user_course = current_user.user_courses.detect { |uc| uc.course_id == course.id }.try(:decorate)
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      session[:requested_path] = request.original_fullpath
      redirect_to root_path(require_signin: true)
    end
  end

  def require_sign_up
    unless logged_in?
      session[:requested_path] = request.original_fullpath
      redirect_to root_path(require_signup: true)
    end
  end

  def set_requested_path
    unless logged_in?
      session[:requested_path] = request.original_fullpath
    end
  end

  def user_not_authorized(e)
    flash[:error] = "You are not authorized to perform this action."
    redirect_to root_path
  end

  def set_facebook_key
    gon.facebook_key = ENV['FACEBOOK_KEY']
  end

  def fetch_notifications
    if logged_in?
      @notifications          = Notification.where(user_id: current_user.id)
      @comment_notifications  = CourseComment.where(id: @notifications.collect { |x| x.notifiable_id }).includes(:chapter, :course).order("created_at desc")
      @new_notification_count = @notifications.reject { |x| x.viewed == true }.count
    end
  end

  def fetch_courses
    @fetched_courses = current_user.courses.limit(3).decorate if logged_in?
  end

  def kiss_metrics_init
    unless @km_identity = cookies[:km_identity]
      @km_identity = SecureRandom.urlsafe_base64
      cookies[:km_identity] = { value: @km_identity, expires: 5.years.from_now }
    end
    if current_user
      unless cookies[:km_aliased]
        KMTS.alias(@km_identity, current_user.email)
        cookies[:km_aliased] = { value: true, expires: 5.years.from_now }
      end
      @km_identity = current_user.email
    end
  end

  def track_event(event, data = {})
    EventTracker.track(@km_identity, event, data)
  end

  def set_admin
    @body_class = 'admin'
  end
end
