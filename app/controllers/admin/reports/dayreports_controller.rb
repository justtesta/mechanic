class Admin::Reports::DayreportsController < Admin::ApplicationController
	before_action :redirect_user
    def index
    	@end_date = if(params[:end_date].present?) 
	      Date.parse(params[:end_date])
	    else
	      Date.today 
	    end 
	    if @end_date.present?
	      @orders=Order.settleds.where(finish_working_at: (@end_date)..(@end_date+1.day))
	      @partchecks=Partchecks.where(created_at: (@end_date)..(@end_date+1.day))
	    end

	    @orders_profit=@orders.map { |e|  e.profit}.sum
	    @partchecks_profit=@partchecks.map { |e|  e.procedure_price}.sum
	    @profit=@orders_profit+@partchecks_profit
    
    end
end