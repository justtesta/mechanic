class ConfirmOrder < ApplicationRecord
	validates_uniqueness_of :order_id
end
