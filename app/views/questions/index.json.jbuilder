json.array!(@questions) do |question|
  json.extract! question, :id, :course_id, :text_question, :subject, :order, :visibility, :user_id
  json.url question_url(question, format: :json)
end
