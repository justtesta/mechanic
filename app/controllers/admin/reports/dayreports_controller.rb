class Admin::Reports::DayreportsController < Admin::ApplicationController
	before_action :redirect_user
    def index
    	@start_date = if(params[:start_date]) 
	      Date.parse(params[:start_date])
	    else
	      Date.today
	    end
    	@end_date = if(params[:end_date].present?) 
	      Date.parse(params[:end_date])
	    else
	      Date.today 
	    end 
	    if @end_date.present?
	      @orders=Order.settleds.where(finish_working_at: (@start_date)..(@end_date+1.day))
	      @partchecks=Partcheck.where(created_at: (@start_date)..(@end_date+1.day))
	      @confirm_orders=@orders.where(confirm_type_cd:[1,5])
	      @withdrawal_orders=@orders.where(confirm_type_cd:[2,3,4])
	      @confirm_partchecks=@partchecks.where(confirm_type_cd:[1,5])
	      @withdrawal_partchecks=@partchecks.where(confirm_type_cd:[2,3,4])
	    end

	    @orders_profit=@orders.joins(:partchecks).where("count(partchecks.id)>0").sum(:procedure_price)
	    @partchecks_profit=@partchecks.map { |e|  e.procedure_price}.sum
	    @profit=@orders_profit+@partchecks_profit
	    
	    @confirm_orders_mechanic_income=@confirm_orders.map { |e|  e.mechanic_income}.sum
	    @confirm_partchecks_mechanic_income=@confirm_partchecks.map { |e|  e.mechanic_income}.sum
	    @confirm_mechanic_income=@confirm_orders_mechanic_income+@confirm_partchecks_mechanic_income

	    @withdrawal_orders_mechanic_income=@withdrawal_orders.map { |e|  e.mechanic_income}.sum
	    @withdrawal_partchecks_mechanic_income=@withdrawal_partchecks.map { |e|  e.mechanic_income}.sum
	    @cwithdrawal_mechanic_income=@withdrawal_orders_mechanic_income+@withdrawal_partchecks_mechanic_income

    
    end
end