object @course_comment => :course_comment
attributes :id, :course_id, :chapter_id, :comment,
           :comment_user_user_name, :comment_user_profile_image_url,
           :created_at_ago_human, :course_allows_voting, :voters,
           :tally_to_s, :depth, :image_url, :parent_id

node(:created_at_human)     { |course_comment| "#{time_ago_in_words(course_comment.created_at)} ago"}
node(:allows_voting) { |course_comment| policy(course_comment).vote? && course_comment.visible }

node :current_user_can_vote do |course_comment|
  votes = (course_comment.voters || {})['up']
  if votes
    !votes.include?(current_user.id)
  else
    true
  end
end

node(:vote_type) { @vote_type }
node :current_user_vote_type do |course_comment|
  votes = (course_comment.voters || {})['up']

  if votes && votes.include?(current_user.id)
    'unlike'
  else
    'like'
  end
end
