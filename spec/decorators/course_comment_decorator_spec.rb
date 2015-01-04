require 'spec_helper'

describe CourseCommentDecorator do

  let(:user_course) { create :user_course }
  let(:course) { user_course.course }
  let(:user) { user_course.user }
  let(:admin) { create :admin }
  let(:topic) { course.comments.create(comment: "Topic 1", user: admin) }
  let(:comment) { course.comments.create(comment: "Hello World", parent: topic, user: user, visible: true).decorate }
  let(:voter) { CommentVoter.new(user, comment) }

  describe '#tally_to_s' do
    context 'with no votes' do
      it 'produces a string that includes up and down votes' do
        expect(comment.tally_to_s).to eq('(+0/-0)')
      end
    end

    context 'with an upvote' do
      before do
        voter.vote('up')
      end

      it 'produces a string that includes up and down votes' do
        expect(comment.tally_to_s).to eq('(+1/-0)')
      end
    end

    context 'with a downvote' do
      before do
        voter.vote('down')
      end

      it 'produces a string that includes up and down votes' do
        expect(comment.tally_to_s).to eq('(+0/-1)')
      end
    end
  end

  describe '#can_vote?' do
    context 'with no votes' do
      it 'returns true for up' do
        expect(comment.can_vote?('up', user)).to be_true
      end

      it 'returns true for down' do
        expect(comment.can_vote?('down', user)).to be_true
      end
    end

    context 'with an upvote' do
      before do
        voter.vote 'up'
      end

      it 'returns false for up' do
        expect(comment.can_vote?('up', user)).to be_false
      end

      it 'returns true for down' do
        expect(comment.can_vote?('down', user)).to be_true
      end
    end


    context 'with a downvote' do
      before do
        voter.vote 'down'
      end

      it 'returns false for down' do
        expect(comment.can_vote?('down', user)).to be_false
      end

      it 'returns true for up' do
        expect(comment.can_vote?('up', user)).to be_true
      end
    end
  end
end
