class Instructor < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name,
            presence: true,
            uniqueness: true

  validates :short_bio,
            presence: true

  validates :long_bio,
            presence: true

  validates :slug,
            presence: true

  validates :email,
            presence: true

  has_and_belongs_to_many :courses
  has_many :images, as: :imageable, dependent: :destroy
  belongs_to :user

  def first_name
    name.split(' ').first
  end

  def last_name
    name.split(' ').last
  end
end
