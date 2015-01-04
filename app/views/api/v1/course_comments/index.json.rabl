object false
child @results => :course_comments do
  collection @results
  attributes :id, :course_id, :chapter_id, :comment, 
             :comment_user_user_name, :comment_user_profile_image_url,
             :created_at_ago_human, :course_allows_voting, :voters, :tally_to_s, :depth,
             :image_url, :parent_id

  node(:created_at_human)     { |course_comment| "#{time_ago_in_words(course_comment.created_at)} ago"}
  node(:allows_voting) { |course_comment| policy(course_comment).vote? && course_comment.visible }

  node :current_user_can_vote do |course_comment|
    votes = (course_comment.voters || {})['up']
    if votes
      if @current_user
        !votes.include?(@current_user.id)
      else
        !votes.include?(current_user.id)
      end
    else
      true
    end
  end

  node :current_user_vote_type do |course_comment|
    votes = (course_comment.voters || {})['up']

    if votes && votes.include?(current_user.id)
      'unlike'
    else
      'like'
    end
  end
end

node(:prev_page_url)  { @prev_page_url }
node(:next_page_url)  { @next_page_url }
node(:last_id)        { @last_id }
node(:first_id)       { @first_id }
node(:total_items)    { @total_items }
node(:items_left)     { @items_left }
node(:items_before)   { @items_before }
node(:focus_id)       { @focus_id }
node(:focus_parent_id){ @focus_parent_id }
node(:focused)        { @focused }
node(:requester_id)   { @requester_id }
