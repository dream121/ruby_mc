class ExperimentValue < ActiveRecord::Base
  validates :experiment, presence: true
  validates :variation, presence: true
  validates :key, presence: true
  validates :value, presence: true
end
