class Partcheck < ApplicationRecord
	belongs_to :orders

	def default_new default_order
		self.new
		self.order_id=default_order.id
		_check_scale=0
		_check_scale=default_order.numbers.checked_numbers.count/default_order.numbers.count if default_order.numbers.count>0
		self.quoted_price=default_order.quoted_price*_check_scale
		self.quantity=default_order.quantity*_check_scale
		self.mechanic_income=default_order.mechanic_income*_check_scale
		self.procedure_price=default_order.procedure_price*_check_scale		
	end
	
	def profit
		procedure_price		
	end
end
