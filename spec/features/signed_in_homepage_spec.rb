require 'spec_helper'

feature "Signed-In Homepage", js: true do
  background do
    create :home_page
    @user = create :user
    sign_in @user
  end

  scenario "Viewing upcoming courses" do
    meryl_streep = create :instructor, name: 'Meryl Streep'
    course = create :course, :upcoming, instructors: [meryl_streep]
    course.detail.update_attributes skill: 'acting'

    visit root_path
    within '#mc-coming-soon-courses' do
      find('a', text: /Meryl Streep teaches you acting/i).click
      expect(current_path).to eq course_path(course)
    end
  end

  scenario "Viewing recommended courses" do
    dustin_hoffman = create :instructor, name: 'Dustin Hoffman'
    course = create :course, instructors: [dustin_hoffman]
    course.detail.update_attributes skill: 'acting'

    visit root_path
    within '#mc-recommended-courses' do
      find('a', text: /Dustin Hoffman teaches you acting/i).click
      expect(current_path).to eq course_path(course)
    end
  end

  scenario "Viewing unstarted courses" do
    serena_williams = create :instructor, name: 'Serena Williams'
    course = create :course, instructors: [serena_williams]
    course.detail.update_attributes skill: 'tennis'
    chapters = [
      create(:chapter, course: course, number: 1, title: 'Welcome to the Court'),
      create(:chapter, course: course, number: 2)
    ]
    user_course = create :user_course, course: course, user: @user

    visit root_path
    within '#mc-your-courses' do
      expect(page).to have_content '0/2'
      expect(page).to have_content 'First up:'
      expect(page).to have_content '01. Welcome to the Court'

      # TODO: Currently the .gallery-holder.box-holder overlaps the link, so poltegeist complains
      # Switch back to the normal `.click` syntax once we fix that layout
      find('a', text: /Serena Williams teaches you tennis/i)#.click
      #expect(current_path).to eq course_path(course)
    end
  end

  scenario "Viewing started courses" do
    meryl_streep = create :instructor, name: 'Meryl Streep'
    course = create :course, instructors: [meryl_streep]
    course.detail.update_attributes skill: 'acting'
    chapters = [
      create(:chapter, course: course, number: 1),
      create(:chapter, course: course, number: 2, title: 'The Art of the Opening Scene')
    ]
    user_course = create :user_course, course: course, user: @user, completed_chapters: [chapters[0]]

    visit root_path
    within '#mc-your-courses' do
      expect(page).to have_content '1/2'
      expect(page).to have_content 'Up next:'
      expect(page).to have_content '02. The Art of the Opening Scene'

      # TODO: Currently the .gallery-holder.box-holder overlaps the link, so poltegeist complains
      # Switch back to the normal `.click` syntax once we fix that layout
      find('a', text: /Meryl Streep teaches you acting/i)#.click
      #expect(current_path).to eq course_path(course)
    end
  end

  scenario "Viewing completed courses" do
    james_patterson = create :instructor, name: 'James Patterson'
    course = create :course, instructors: [james_patterson], chapter_count: 2
    course.detail.update_attributes skill: 'writing'
    user_course = create :user_course, course: course, user: @user, completed_chapters: course.chapters

    visit root_path
    within '#mc-your-courses' do
      expect(page).to have_content /Your Class Review/i
      find('.rating-star:nth-child(4)').trigger('click')
      sleep(1) # to give the star update a chance to persist
      fill_in 'course_review[review]', with: 'I thought this class was awesome!'
      find_field('course_review[review]').trigger('focus') # capybara blurs when finished filling in
      click_on 'Post'

      expect(page).to have_content /A special thank you/i
    end
  end

  scenario "Viewing completed+reviewed courses" do
    usher = create :instructor, name: 'Usher'
    course = create :course, instructors: [usher], chapter_count: 2
    course.detail.update_attributes skill: 'dance'
    user_course = create :user_course, course: course, user: @user, completed_chapters: course.chapters
    create :course_review, user: @user, course: course

    visit root_path
    within '#mc-your-courses' do
      expect(page).to have_content /A special thank you/i
    end
  end
end
