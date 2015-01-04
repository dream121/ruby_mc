class EmailTemplate < ActiveRecord::Base
  belongs_to :course

  validates :subject, :body, :from, :course_id, presence: true
end
