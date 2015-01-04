require 'spec_helper'

describe UserCourseDecorator do

  let(:user_course) { build(:user_course, course: course).decorate }
  let(:course) { build(:course) }
  let(:progress) do
    {
      "1" => { "position" => "1.11", "duration" => "2.22" },
      "2" => { "position" => "3.33", "duration" => "4.44" },
      "3" => { "position" => "5.55", "duration" => "5.56" }
    }
  end

  before do
    course.stub(:chapters).and_return([
      build_stubbed(:chapter, id: 1),
      build_stubbed(:chapter, id: 2),
      build_stubbed(:chapter, id: 3)
    ])
  end

  describe '#update_progress' do
    before do
      user_course.progress = { "1" => { "position" => "1.11", "duration" => "2.22" }, "3" => { "position" => "5.55", "duration" => "5.56" } }
      user_course.save!
    end

    it 'updates progress for the given chapter' do
      user_course.update_progress(:chapter_id => "2", "position" => "3.33", "duration" => "4.44")
      user_course.reload
      expect(user_course.progress).to eq(progress)
    end
  end

  describe '#progress_for_chapter' do
    before do
      user_course.progress = progress
    end

    it 'returns progress for a given chapter ID' do
      progress = user_course.progress_for_chapter(1)
      expect(progress.position).to eq 1.11
      expect(progress.duration).to eq 2.22
      expect(progress.percent_complete).to eq(50.0)
    end

    it 'returns 0% complete if no progress for a given chapter' do
      progress = user_course.progress_for_chapter(9)
      expect(progress.percent_complete).to eq(0.0)
    end
  end

  describe '#chapters_started' do
    before do
      user_course.progress = progress
    end

    it 'returns the number of chapters started' do
      expect(user_course.chapters_started.length).to eq(3)
    end
  end

  describe '#chapters_completed' do
    before do
      user_course.progress = progress
    end

    it 'returns the number of chapters started' do
      expect(user_course.chapters_completed.length).to eq(1)
    end
  end

  describe '#progress_icon_for_chapter' do
    before do
      user_course.progress = progress
    end

    it 'returns the play icon for a chapter with 50% progress' do
      icon = user_course.progress_icon_for_chapter(1)
      expect(icon).to eq('icon-play')
    end

    it 'returns the play icon if no progress for a given chapter' do
      icon = user_course.progress_icon_for_chapter(9)
      expect(icon).to eq('icon-play')
    end

    it 'returns the checkmark icon for a chapter that is nearly complete' do
      icon = user_course.progress_icon_for_chapter(3)
      expect(icon).to eq('icon-checkmark')
    end
  end

  describe '#welcome_statement' do
    context 'when a user has watched videos' do
      before do
        user_course.progress = progress
      end

      it 'returns the course welcome back statement' do
        expect(user_course.welcome_statement).to eq('Welcome Back!')
      end
    end

    context 'when a user has not watched videos' do
      before do
        user_course.progress = {}
      end

      it 'returns the course welcome statement' do
        expect(user_course.welcome_statement).to eq('Welcome!')
      end
    end
  end

end
