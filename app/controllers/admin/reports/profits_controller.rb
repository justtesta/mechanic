class Admin::Reports::ProfitsController < Admin::ApplicationController
	before_action :redirect_user
    def index
   		Order.all
    end
end