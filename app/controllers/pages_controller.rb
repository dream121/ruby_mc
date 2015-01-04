class PagesController < ApplicationController
  before_filter :require_login, only: [:edit, :update]
  before_action :set_home_page, only: [:edit, :update]

  def edit
    render :edit, :layout => 'application'
  end

  def update
    @home_page.update(page_params)
    redirect_to root_path
  end

  def root
    track_event 'pages.root'
    # @message = Message.new
    # @featured_courses = Course.all.limit(3)
    if current_user
      @my_courses = current_user.courses if current_user
      @recommended_courses = current_user.recommended_courses
      @coming_courses = current_user.coming_courses
    else
      @recommended_courses = Course.recommended
      @coming_courses = Course.where(available_now: false)
    end

    @courses = @recommended_courses + @coming_courses
    @home_page = HomePage.first.decorate

    @reset_password_token = params[:reset_password_token]
    @identity = Identity.find_by(password_reset_token: @reset_password_token) if @reset_password_token

    render :root, :layout => 'root'
  end

  def terms
    track_event 'pages.terms'
  end
  def privacy
    track_event 'pages.privacy'
  end

  def contact
    track_event 'pages.contact'
  end

  def about_us
    track_event 'pages.about_us'
  end

  def faq
    track_event 'pages.faq'
  end

  def how_it_works

    track_event 'pages.how_it_works'
  end

  private

  def page_params
    params.require(:home_page).permit(:tweet_text, :fb_headline, :fb_description, :fb_link)
  end

  def set_home_page
    @home_page = HomePage.first || HomePage.create
  end
end
