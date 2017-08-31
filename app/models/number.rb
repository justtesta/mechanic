class Number < ApplicationRecord
  belongs_to :order
  def left_number
    pwd_number_default[0,9]
  end
  def right_number
    pwd_number_default[10,12]
  end
end
