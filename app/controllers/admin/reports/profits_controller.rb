class Admin::Reports::ProfitsController < Admin::ApplicationController
	before_action :redirect_user
    def index
   		@orders=Order.settleds.where("finish_working_at>'2017-10-31 23:59'").includes(:user, :mechanic_user).joins(:user).order(finish_working_at: :desc)   
    end
end