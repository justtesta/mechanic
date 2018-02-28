class Merchants::NumbersController < Merchants::ApplicationController
  before_action :find_order
  before_action :find_number , only: [ :edit, :update, :destroy ]
  


  def index
    @numbers = @order.numbers
  end

  def new
    @number =@order.numbers.new
  end

  def create
    @number = @order.numbers.new(number_params)
    @number.number_type_cd=1
    if @number.save
      redirect_to merchants_order_numbers_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @number.status==0&&@number.number_type_cd==1
      if @number.update_attributes(number_params)
        flash[:notice] = "成功更新核销码！"
        redirect_to merchants_order_numbers_path
      else
        render :show
      end
    else
      flash[:error] = "已经核销或者京东生成的核销码不可删除！"
      render :show
    end
  end


  def destroy
    if @number.status==0&&@number.number_type_cd==1
      flash[:notice] = "成功删除核销码！"
      @number.destroy
    else
      flash[:error] = "已经核销或者京东生成的核销码不可删除！"
    end
    redirect_to merchants_order_numbers_path
  end

  private

    def find_order
        @order = order_klass.find(params[:order_id])
    end

    def find_number
      @number =@order.numbers.find(params[:id])
    end

    def order_klass
      Order.where(user_id: current_store, merchant_id: current_merchant)
    end

    def number_params
      params.require(:number).permit(:pwd_number_default)
    end


end
