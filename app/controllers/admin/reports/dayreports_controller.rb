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
	      @orders=Order.settleds.where(finish_working_at: (@start_date)..(@end_date+1.day)).where(" orders.id not in(select order_id from partchecks where order_id is not null)")
	      @partchecks=Partcheck.where(created_at: (@start_date)..(@end_date+1.day))
	      @confirm_orders=@orders.where(confirm_type_cd:[1,5])
	      @withdrawal_orders=@orders.where(confirm_type_cd:[2,3,4])
	      @confirm_partchecks=@partchecks.where(confirm_type_cd:[1,5])
	      @withdrawal_partchecks=@partchecks.where(confirm_type_cd:[2,3,4])
	    end

	    @orders_profit=@orders.sum(:procedure_price)
	    @partchecks_profit=@partchecks.sum(:procedure_price)
	    @profit=@orders_profit+@partchecks_profit
	    
	    @confirm_orders_mechanic_income=@confirm_orders.sum(:quoted_price)-@confirm_orders.sum(:procedure_price)
	    @confirm_partchecks_mechanic_income=@confirm_partchecks.sum(:mechanic_income)
	    @confirm_mechanic_income=@confirm_orders_mechanic_income+@confirm_partchecks_mechanic_income

	    @withdrawal_orders_mechanic_income=@withdrawal_orders.sum(:quoted_price)-@withdrawal_orders.sum(:procedure_price)
	    @withdrawal_partchecks_mechanic_income=@withdrawal_partchecks.sum(:mechanic_income)
	    @cwithdrawal_mechanic_income=@withdrawal_orders_mechanic_income+@withdrawal_partchecks_mechanic_income

    
    end
end