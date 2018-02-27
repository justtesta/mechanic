class Number < ApplicationRecord
  as_enum :status, unchecked: 0, checked: 1
  belongs_to :order
  def left_number
    pwd_number_default[0,9]
  end
  def out_left_number
    "#{left_number}***"
  end
  def right_number
    pwd_number_default[9,3]
  end
  scope :unchecked_numbers, -> { where(status: 0) }
  scope :checked_numbers, -> { where(status: 1) }
end
