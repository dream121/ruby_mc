class CourseFactDecorator < Draper::Decorator
  delegate_all

  def image_kinds
    %w(icon)
  end

  def fact_kinds
    ['headline', 'core_skills', 'asset', 'statistic', 'interaction']
  end
end
