object false
collection @results
attributes :id, :comment, :created_at, :updated_at, :image_url

node(:chapter_href) { |comment| watch_course_chapter_path(comment.course, comment.chapter) }
node(:discussion_href) { |comment| watch_course_chapter_path(comment.course, comment.chapter, comment_id: comment.id) }

child(:user) do
  attributes :id, :full_name
  node(:image_url) { |u| u.decorate.user_profile_img_url }
end

child(:chapter) do
  attributes :id, :number, :title
  node(:padded_number) { |ch| sprintf '%02d', ch.number }
end

