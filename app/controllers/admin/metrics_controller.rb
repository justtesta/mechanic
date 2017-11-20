class Admin::MetricsController < Admin::ApplicationController


  def index
    @metrics = if params[:mechanic_id]
        @mechanic = Mechanic.where(user_id: params[:mechanic_id]).first!
        Metric.where(user_id: params[:mechanic_id])
      else
      	if params[:merchant_id]
	        @merchant = Merchant.where(user_id: params[:merchant_id]).first!
	        Metric.where(user_id: params[:merchant_id])
	    else
	      	Metric.all
	    end
      end
  end

  private

end
