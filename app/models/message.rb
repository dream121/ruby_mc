class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  EMAIL_REGEXP = /.+@.+\..+/i

  attr_accessor :subject, :body, :from, :to

  validates :subject, :body, :from, :to, :presence => true
  validates :from, format: EMAIL_REGEXP
  validates :to, format: EMAIL_REGEXP

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

end
