require 'spec_helper'

feature "Forums", js: true do
  background do
    @user_course = create :user_course
    @course = @user_course.course
    @user = @user_course.user
    @topic = @course.comments.create comment: 'Topic 1'

    ApplicationController.any_instance.stub(:current_user).and_return @user
    ApplicationController.any_instance.stub(:logged_in?).and_return true
  end

  scenario "An enrolled user should be able to create a comment" do
    visit enrolled_course_path(@course)
    click_link 'forum'

    within '.tab-content' do
      find('.topic-description', text: 'Topic 1').click
    end

    expect(page).to have_content "Add a comment to Topic 1"
    find("textarea[data-parent-id='#{@topic.id}']").set('My Comment')
    find("input[type=submit]").click
    find('.comment .details .words', text: 'My Comment')
  end
end
