  class Admin::Reports::PartchecksController < Admin::ApplicationController
  	before_action :redirect_user,:redirect_super_admin

	def index
	    @partchecks = if params[:order_id] 
	    	@order = Order.find(params[:order_id])
	    	@order.partchecks
	    else
	    	Partcheck.all.order(created_at: :desc)
	    end


	end

  end