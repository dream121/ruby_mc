require 'spec_helper'

describe CommentVoter do
  let(:comment) { build_stubbed(:course_comment) }
  let(:user) { build_stubbed :user }
  let(:voter) { CommentVoter.new(user, comment) }

  context 'voting' do
    it 'allows each user only one upvote' do
      voter.vote(:up)
      expect(comment.votes).to eq(1)
      expect(comment.voters['up']).to eq([user.id])
      expect(comment.voters['down']).to eq([])
      voter.vote(:up)
      expect(comment.votes).to eq(1)
      expect(comment.voters['up']).to eq([user.id])
      expect(comment.voters['down']).to eq([])
    end

    it 'allows each user to downvote to undo their upvote' do
      voter.vote(:up)
      expect(comment.votes).to eq(1)
      expect(comment.voters['up']).to eq([user.id])
      expect(comment.voters['down']).to eq([])
      voter.vote(:down)
      expect(comment.votes).to eq(0)
      expect(comment.voters['up']).to eq([])
      expect(comment.voters['down']).to eq([])
    end

    it 'allows each user only one downvote' do
      voter.vote(:down)
      expect(comment.votes).to eq(-1)
      expect(comment.voters['up']).to eq([])
      expect(comment.voters['down']).to eq([user.id])
      voter.vote(:down)
      expect(comment.votes).to eq(-1)
      expect(comment.voters['up']).to eq([])
      expect(comment.voters['down']).to eq([user.id])
    end

  end
end
