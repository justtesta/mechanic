class Merchants::Hosting::PartchecksController < Merchants::ApplicationController
  before_action :redirect_user_dispatcher
  def index
    @order = Order.hostings.find(params[:order_id])
    @partchecks = @order.partchecks
  end

  
end