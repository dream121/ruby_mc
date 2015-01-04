class QuestionCreator
  def self.init_hash(n, user_id, course_id)
    {
      course_id: course_id,
      subject: "This is question #{n + 1}",
      visibility: true,
      user_id: user_id,
      position: n,
      brightcove_id: '2743641247001',
    }
  end

  def self.answer_hash(question_id, user_id)
    {
      question_id: question_id,
      user_id: user_id,
      brightcove_id: '2743641246001'
    }
  end

  def self.create_questions(amt, course_id, user_id)
    Question.where(course_id: course_id).delete_all
    amt.times do |num|
      q = Question.create(self.init_hash(num, user_id, course_id))
      a = Answer.create(self.answer_hash(q.id, user_id))
    end
  end

end
