class CourseFact < ActiveRecord::Base
  belongs_to :course
  has_one :image, as: :imageable, dependent: :destroy

  class << self
    ['headline', 'core_skills', 'asset', 'statistic', 'interaction'].each do |method|
      define_method(method) do
        sorted_kind method
      end
    end
  end

  private

  class << self
    def sorted_kind(kind)
      where(kind: kind).order(:position)
    end
  end

end
