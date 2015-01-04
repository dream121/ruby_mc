class QuestionDecorator < Draper::Decorator
  delegate_all

  def decorated_user
    model.user
  end

  def question_thumb_url
    model.thumb_url
  end

  def answer_thumb_url
    if model.answer
      model.answer.thumb_url
    end
  end

  def answer_brightcove_id
    if model.answer
      model.answer.brightcove_id
    end
  end

  def question_course
    model.course
  end

  def instructor_name
    if question_course
      question_course.instructors.first.name.to_s.split(" ")[0].capitalize
    end
  end

  def user_name
    if model.user
      user.name
    else
      'Reginald Smith'
    end
  end

  def answer
    model.answer
  end

  def answer_user_name
    if model.answer
      if model.answer.user
        model.answer.user.name
      else
        'Jonathan Baker'
      end
    else
      'Jonathan Baker'
    end
  end

end
