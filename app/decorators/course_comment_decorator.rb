class CourseCommentDecorator < Draper::Decorator
  delegate_all
  @comment_user

  def tally_to_s
    # data = %w(up down).map do |direction|
    #   votes = votes_for(direction)
    #   [sign_for(direction), votes].join
    # end.join('/')
    # data = votes_for('up')
    # "#{data}"
    if votes.nil?
      "0"
    else
      votes.to_s
    end
  end

  def comment_user
    @comment_user ||= object.user.decorate
  end

  def comment_user_profile_image_url
    if comment_user
      comment_user.user_profile_img_url
    end
  end

  def created_at_human
    h.time_ago_in_words(object.created_at)
  end

  def comment_user_user_name
    if comment_user
      comment_user.user_name
    end
  end

  def votes_with_sign
    if votes.to_i > 0
      "+#{votes}"
    else
      votes
    end
  end

  def votes_class
    case
    when votes.to_i > 0
      'text-success'
    when votes.to_i < 0
      'text-danger'
    else
      'text-muted'
    end
  end

  def can_vote?(direction, user)
    votes = (voters || {})[direction]
    if votes
      !votes.include?(user.id)
    else
      true
    end
  end

  private

  def votes_for(direction)
    (voters || {})[direction].try(:length).to_i
  end

  def sign_for(direction)
    direction == 'up' ? '+' : '-'
  end
end
