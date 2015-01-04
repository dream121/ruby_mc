class InstructorDecorator < Draper::Decorator
  delegate_all

  def image_kinds
    ['headshot', 'hero', 'popular_quote_logo']
  end
end
