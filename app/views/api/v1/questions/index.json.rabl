object false

child @results => :questions do
  collection @results
  attributes :id, :course_id, :created_at, :updated_at,
             :text_question, :subject, :visibility,
             :position, :user_name, :question_thumb_url, :answer_user_name,
             :answer_thumb_url, :brightcove_id, :answer_brightcove_id
end

node(:prev_page_url)  { @prev_page_url }
node(:next_page_url)  { @next_page_url }
node(:last_id)        { @last_id }
node(:first_id)       { @first_id }
node(:total_items)    { @total_items }
node(:items_left)     { @items_left }
