class Number < ApplicationRecord
  belongs_to :order
  def left_number
    pwd_number_default[0,9]
  end
  def right_number
    pwd_number_default[9,3]
  end
  scope :unchecked_numbers, -> { where(status: 0) }
  scope :checked_numbers, -> { where(status: 1) }
end
