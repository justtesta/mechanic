class Partcheck < ApplicationRecord
	belongs_to :orders
	
	def profit
		procedure_price		
	end
end
