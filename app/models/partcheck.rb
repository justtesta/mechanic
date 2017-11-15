class Partcheck < ApplicationRecord
	belongs_to :order

	def set_default default_order
		byebug
		self.order_id=default_order.id
		_check_scale=0
		_check_scale=default_order.numbers.checked_numbers.count/default_order.numbers.count if default_order.numbers.count>0
		self.quoted_price=default_order.quoted_price * _check_scale
		self.quantity=default_order.quantity * _check_scale if default_order.quantity
		self.mechanic_income=default_order.mechanic_income * _check_scale if default_order.mechanic_income
		self.procedure_price=default_order.procedure_price * _check_scale	if default_order.procedure_price	
	end
	
	def profit
		procedure_price		
	end
end
