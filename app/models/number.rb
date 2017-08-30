class Number < ApplicationRecord
  belongs_to :order
  def left_number
    pwd_number_default.left(9)
  end
end
