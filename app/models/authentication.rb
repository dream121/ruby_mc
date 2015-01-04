class Authentication < ActiveRecord::Base
  belongs_to :user
  has_one :identity, dependent: :destroy
  validates :provider, :uid, presence: true
end
