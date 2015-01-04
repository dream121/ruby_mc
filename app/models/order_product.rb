class OrderProduct < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :product_id, presence: true
end
