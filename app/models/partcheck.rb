class Partcheck < ApplicationRecord
	belongs_to :order

	def set_default default_order
		self.order_id=default_order.id
		self.quoted_price=default_order.quoted_price * default_order.numbers.checked_numbers.count/default_order.numbers.count if default_order.numbers.count>0
		self.quantity=default_order.quantity * default_order.numbers.checked_numbers.count/default_order.numbers.count if default_order.numbers.count>0 && default_order.quantity
		self.mechanic_income=default_order.mechanic_income * default_order.numbers.checked_numbers.count/default_order.numbers.count if default_order.numbers.count>0 &&  default_order.mechanic_income
		self.procedure_price=default_order.procedure_price * default_order.numbers.checked_numbers.count/default_order.numbers.count if default_order.numbers.count>0 &&  default_order.procedure_price	
	end
	
	def profit
		procedure_price		
	end
end
