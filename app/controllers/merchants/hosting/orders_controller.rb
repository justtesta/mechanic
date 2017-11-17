class Merchants::Hosting::OrdersController < Merchants::OrdersController
  before_action :redirect_user
  before_action :redirect_user_dispatcher, only: [ :confirm, :confirmwithdrawal ]
  skip_before_action :redirect_user, only: [:automatic]
  skip_before_action :redirect_user_dispatcher, only: [:automatic]
  skip_before_action :authenticate!, only: [:automatic]
  before_action :find_order, except: [ :index, :new, :create, :notify, :not_found , :automatic]


  def index
    @state = if %w(unassigneds assigneds workings confirmings finisheds unfinisheds emergencys finished_nochecks unfinished_checks).include? params[:state]
        params[:state].to_sym
      else
        :unassigneds
      end
    
    @orders = order_klass.send(@state)
  end
  


  def update_pick
    mechanic_id = params[:order][:mechanic_id]
    if mechanic_id.present?
      remark = params[:order][:remark]
      pre_remark = params[:order][:pre_remark]
      remark = pre_remark if pre_remark
      @order.update_attribute(:remark, remark) if remark
      procedure_price = params[:order][:pre_procedure_price]
      if(procedure_price.present?)
        if procedure_price.to_i > @order.quoted_price
        @order.errors.add(:pre_procedure_price, "应低于订单标价")
        render :show
        return 
        end
      end
      @order.update_attribute(:procedure_price, procedure_price) if procedure_price
      mechanic = Mechanic.find(mechanic_id)
      @order.repick! mechanic,current_merchant.id,current_merchant.nickname
      redirect_to current_order_path
    else
      @order.remark = params[:order][:remark]
      @order.errors.add :base, "请选择一个技师"
      render :pick
    end
  end

  def update_procedure_price
    if @order.update_attributes(procedure_price_order_params)
      redirect_to current_order_path
    else
      render :procedure_price
    end
  end

  def automatic
    Order.hostings.unassigneds.where("skill_cd=28 or skill_cd=29 or skill_cd=42 or skill_cd=9 or skill_cd=34 or skill_cd=44 ").each do |unassigned_order_klass|
       unassigned_order_klass_order=Order.find(unassigned_order_klass.id)
       unassigned_order_klass_order.automatic_repick!
    end 
    #trigger automatic_repick
  end 

  private

    def current_order_path
      merchants_hosting_order_path(@order)
    end

    def redirect_pending
      ordercount = order_klass.confirmings.count
      if ordercount>0
        flash[:notice] = "您有#{ordercount}条需要确认完工的订单..."
        #redirect_to merchants_hosting_order_path(order)
      end
    end

    def order_klass
      Order.hostings
    end

    def find_order
      @order = order_klass.find(params[:id])
    end

    alias_method :find_store_order, :find_order

    def redirect_user
      unless current_store.host?
        flash[:error] = "无法访问此页面！"
        redirect_to merchants_root_path
      end
    end

    def remark_order_params
      params.require(:order).permit(:hosting_remark)
    end

    def procedure_price_order_params
      params.require(:order).permit(:procedure_price)
    end
end
