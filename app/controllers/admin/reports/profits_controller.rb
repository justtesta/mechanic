class Admin::Reports::ProfitsController < Admin::ApplicationController
	before_action :redirect_user
    def index
   		@orders=Order.settleds.where("confirm_by>0").order(finish_working_at: :desc)   
    end
end