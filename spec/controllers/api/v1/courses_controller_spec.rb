require 'spec_helper'

describe Api::V1::CoursesController do
  render_views

  let(:user) { create :user }

  before do
    sign_in user

    @course_1 = create(:course, chapter_count: 3)
    detail = create(:course_detail, course: @course_1, tweet_text: 'Some tweeting')
    @course_1.instructors = [create(:instructor)]
    @course_1.save
    @course_1.reload

    completed_chapters = @course_1.chapters.select { |chapter| chapter.number < 3 }
    @user_course_1      = create(:user_course, user: user, course: @course_1, completed_chapters: completed_chapters)
    @user_course_2      = create(:user_course, user: user)

    @other_user_course  = create(:user_course)
    @recommended_course = create(:course, :recommended)
    @upcoming_course    = create(:course, :upcoming)
  end

  describe "#index" do
    context "when the user is enrolled" do
      before do
        get :index, { format: 'json' }
        expect(response.code).to eq '200'

        @course_titles = json.map {|course| course['title']}
      end

      it "returns all the user's courses" do
        expect(@course_titles).to match_array [@user_course_1.course.title, @user_course_2.course.title]
      end

      it "does not return courses the user is not enrolled in" do
        expect(@course_titles).not_to include @other_user_course.course.title
        expect(@course_titles).not_to include @recommended_course.title
        expect(@course_titles).not_to include @upcoming_course.title
      end

      it "returns relevant course fields" do
        course_1 = @user_course_1.course.decorate
        course_1_json = json.detect {|course_json| course_json['id'] == course_1.id}

        expect(course_1_json['title']).to eq                 course_1.title
        expect(course_1_json['overview']).to eq              course_1.overview
        expect(course_1_json['skill']).to eq                 course_1.skill
        expect(course_1_json['banner_image_url']).to eq      course_1.image_url
        expect(course_1_json['show_url']).to eq              course_url(course_1)
        expect(course_1_json['reviews_url']).to eq           course_reviews_url(course_1)
        expect(course_1_json['enrolled_url']).to eq          enrolled_course_url(course_1)
        expect(course_1_json['instructor_name']).to eq       course_1.instructor_name
        expect(course_1_json['instructor_first_name']).to eq course_1.instructor_first_name
        expect(course_1_json['chapter_count']).to eq         course_1.chapter_count
        expect(course_1_json['tweet_text']).to eq            course_1.tweet_text
      end

      it "returns user-specific data" do
        course_1 = @user_course_1.course.decorate
        course_1_json = json.detect {|course_json| course_json['id'] == course_1.id}

        expect(course_1_json['state']).to eq                   'enrolled'
        expect(course_1_json['completed_chapter_count']).to eq 2
        expect(course_1_json['next_chapter_number']).to eq     3
        expect(course_1_json['next_chapter_title']).to eq      course_1.chapters[2].title
      end
    end

    context "when the user has completed the course" do
      before do
        @course_3 = create(:course, chapter_count: 3)
        user_course_3 = create(:user_course, user: user, course: @course_3, completed_chapters: @course_3.chapters)

        get :index, { format: 'json' }
        expect(response.code).to eq '200'
      end

      it "returns a state of 'completed'" do
        course_3_json = json.detect {|course_json| course_json['id'] == @course_3.id}
        expect(course_3_json['state']).to eq 'completed'
      end
    end

    context "when the user has reviewed the course" do
      before do
        @course_3 = create(:course, chapter_count: 3)
        create :course_review, course_id: @course_3.id, user_id: user.id
      end

      context "when the user has not completed the course" do
        before do
          create(:user_course, user: user, course: @course_3, completed_chapters: [])
        end

        it "returns a state of 'enrolled'" do
          get :index, { format: 'json' }
          expect(response.code).to eq '200'

          course_3_json = json.detect {|course_json| course_json['id'] == @course_3.id}
          expect(course_3_json['state']).to eq 'enrolled'
        end
      end

      context "when the user has completed the course" do
        before do
          @user_course_3 = create(:user_course, user: user, course: @course_3, completed_chapters: @course_3.chapters)
        end

        it "returns a state of 'reviewed'" do
          get :index, { format: 'json' }
          expect(response.code).to eq '200'

          course_3_json = json.detect {|course_json| course_json['id'] == @course_3.id}
          expect(course_3_json['state']).to eq 'reviewed'
        end

        it "returns the latest review" do
          @expected_latest_review = @user_course_3.decorate.latest_review

          get :index, { format: 'json' }
          course_3_json = json.detect {|course_json| course_json['id'] == @course_3.id}

          expect(course_3_json['latest_review']['id']).to     be
          expect(course_3_json['latest_review']['rating']).to eq @expected_latest_review.rating
          expect(course_3_json['latest_review']['review']).to eq @expected_latest_review.review
        end
      end
    end
  end

  describe '#upcoming' do
    before do
      get :upcoming, { format: 'json' }
      expect(response.code).to eq '200'

      @course_ids = json.map {|course| course['id']}
    end

    it 'does not return courses that are currently available' do
      expect(@course_ids).not_to include(@user_course_1.course.id)
      expect(@course_ids).not_to include(@recommended_course.id)
    end

    it 'should include the upcoming course' do
      expect(@course_ids).to match_array([@upcoming_course.id])
    end
  end

  describe '#recommended' do
    before do
      get :recommended, { format: 'json' }
      expect(response.code).to eq '200'

      @course_ids = json.map {|course| course['id']}
    end

    it 'does not return courses that the current_user is enrolled or courses that are not available' do
      expect(@course_ids).not_to include(@user_course_1.course.id, @user_course_1.course.id)
      expect(@course_ids).not_to include(@upcoming_course.id)
    end

    it 'should include the recommended course' do
      expect(@course_ids).to match_array([@recommended_course.id, @other_user_course.course.id])
    end
  end
end
