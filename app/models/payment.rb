class Payment < ActiveRecord::Base
  belongs_to :order

  validates :order_id, presence: true
  validates :amount,
    presence: true,
    numericality: { only_integer: true }

  validates :paid, inclusion: { in: [true, false] }

end
