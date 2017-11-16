class Admin::Reports::ProfitsController < Admin::ApplicationController
	before_action :redirect_user
    def index
   		@orders=Order.settleds.where("orders.confirm_by>0").includes(:user, :mechanic_user).order(finish_working_at: :desc)   
    end
end