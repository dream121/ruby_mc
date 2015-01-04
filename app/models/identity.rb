class Identity < OmniAuth::Identity::Models::ActiveRecord
  EMAIL_REGEXP = /.+@.+\..+/i

  # validates_presence_of :name
  validates_format_of :email, :with => EMAIL_REGEXP
  validates_uniqueness_of :email

  belongs_to :authentication

  before_validation :downcase_email
  validate :no_existing_user, if: Proc.new { |identity| identity.new_record? }

  def password_reset_expired?
    if password_reset_sent_at
      password_reset_sent_at < 2.hours.ago
    else
      true
    end
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def no_existing_user
    if email && user = User.find_by(email: email.downcase)
      message = if user.facebook
        "has already been taken by an account set up via Facebook"
      elsif user.developer
        "has already been taken by a developer"
      else
        "has already been taken"
      end
      errors.add(:email, message) unless errors[:email].any?
    end
  end
end
