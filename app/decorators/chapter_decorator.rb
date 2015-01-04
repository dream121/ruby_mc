class ChapterDecorator < Draper::Decorator
  delegate_all

  def total_comments
    number_of_comments = self.comments.count
    display_comment_count(number_of_comments)
  end

  def total_user_comments user
    comments.where('user_id = ?', user.id).count
  end

  def display_comment_count value
    "#{value} #{'comment'.pluralize(value)}"
  end
end
