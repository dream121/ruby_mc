class User < ActiveRecord::Base
  DEFAULT_PERMISSIONS = {'admin' => false, 'comments' => true }

  # validates :name,
  #           presence: true

  validates :email,
            presence: true,
            email: true,
            uniqueness: true

  has_one :profile
  has_one :cart, dependent: :destroy
  has_one :instructor # only if this user is an instructor
  has_many :authentications, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :courses, -> { where('user_courses.access' => true).order('user_courses.created_at DESC') }, through: :user_courses
  has_many :questions
  has_many :answers

  before_save :downcase_email
  before_save :default_permissions

  def facebook
    authentications.detect{|a| a.provider == 'facebook'}
  end

  def identity
    authentications.detect{|a| a.provider == 'identity'}
  end

  def developer
    authentications.detect{|a| a.provider == 'developer'}
  end

  def admin?
    permissions && permissions['admin']
  end

  def update_permissions(new_permissions)
    permissions_will_change!
    self.permissions ||= {}
    new_permissions.each do |name, value|
      if value == 'true'
        self.permissions[name] = true
      elsif value == 'false'
        self.permissions[name] = false
      else
        self.permissions[name] = value
      end
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # used to satisfy some of the method calls done before
  # name was split into first_name and last_name
  def name
    full_name
  end

  def full_name=(value)
    if value
      name = value.split(' ')
      self.first_name = name.first
      self.last_name = name.last
    end
  end

  def recommended_courses
    Course.recommended_for_user(self)
  end

  def coming_courses
    Course.coming.where.not("id in (?) ", self.courses.collect(&:id))
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def default_permissions
    self.update_permissions(DEFAULT_PERMISSIONS) unless permissions
  end
end
