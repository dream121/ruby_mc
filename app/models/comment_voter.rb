class CommentVoter

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def vote(vote)
    @vote = vote.to_s
    prepare_voters

    if voted_opposite?
      remove_opposite
      update_votes
    elsif !already_voted?
      add_vote
      update_votes
    end
  end


  private

  def opposite_vote
    case @vote
    when 'up'
      'down'
    when 'down'
      'up'
    end
  end

  def update_votes
    @comment.votes ||= 0
    case @vote.to_s
    when 'up'
      @comment.votes += 1
    when 'down'
      @comment.votes -= 1
    end
  end

  def prepare_voters
    @comment.voters_will_change!
    @comment.voters ||= { 'up' => [], 'down' => [] }
  end

  def voted_opposite?
    @comment.voters[opposite_vote].include?(@user.id)
  end

  def remove_opposite
    @comment.voters[opposite_vote].delete_if { |u| u == @user.id }
  end

  def already_voted?
    @comment.voters[@vote].include?(@user.id)
  end

  def add_vote
    @comment.voters[@vote].push(@user.id)
  end
end
