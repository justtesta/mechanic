  class Admin::Reports::PartchecksController < Admin::ApplicationController
  	before_action :redirect_user

	def index
	    @partchecks = if params[:order_id] 
	    	@order = Order.find(params[:order_id])
	    	@order.partchecks
	    else
	    	Partcheck.all
	    end

	    @partcheck = Partcheck.new
	    @partcheck.set_default(@order) 
	end
	
  end