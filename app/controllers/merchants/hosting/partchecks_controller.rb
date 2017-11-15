class Merchants::Hosting::PartchecksController < Merchants::ApplicationController
  before_action :redirect_user_dispatcher

  def index
    @order = Order.hostings.find(params[:order_id])
    @partchecks = @order.partchecks

    @partcheck = Partcheck.new
    @partcheck.set_default(@order) 
  end

  def create
    byebug
    @partcheck = @order.partchecks.new(partcheck_params)
    @partcheck.confirm_by=current_merchant.id
    if @partcheck.save
      @order=Order.hostings.find(@partcheck.order_id)
      @order.update_attribute(:partcheck_order, true)
      redirect_to merchants_hosting_order_path(@order)
    else
      render :index
    end 
  end

  def partcheck_params
    params.require(:partcheck).permit( :quoted_price, :quantity,
    :mechanic_income, :procedure_price)
  end

end