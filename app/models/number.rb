class Number < ApplicationRecord
  as_enum :check_status, [0,1], source: :status
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
  def left_number2
    temp=pwd_number_default.length-3
    pwd_number_default[0,temp]
  end
  def right_number2
    pwd_number_default.last(3)
  end
  scope :unchecked_numbers, -> { where(status: 0) }
  scope :checked_numbers, -> { where(status: 1) }
end
